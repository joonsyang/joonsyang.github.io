#!/usr/bin/env ruby
# frozen_string_literal: true
#
# _data/publications.yml(단일 소스) → cv/publications-generated.tex 생성.
# CV .tex는 \input{publications-generated}로 이 조각을 끼워넣는다.
#
# 섹션 구분: Peer-Reviewed Articles(published, 연도 내림차순) / Forthcoming /
#   Under Review(under-review는 "Revise and Resubmit, 저널" 표기, in-review는 제목만) /
#   Working Papers
# 표기 규칙:
#   - 공저자는 기존 CV 관례대로 [With ...] (본인 제외, yml 순서 유지)
#   - DOI/URL이 있으면 저널명에 \href (URL 문자열은 노출하지 않음)
#   - language: ko → "(In Korean)" 부착, title_original은 CV에 사용하지 않음 (영문 전용)
# 사용법: ruby scripts/build-cv-publications.rb

require "yaml"

ROOT = File.expand_path("..", __dir__)
SELF_NAME = "Joonseok Yang"

def tex_escape(s)
  s.to_s.gsub("&", '\\\&').gsub("%", '\\%').gsub("#", '\\#').gsub("_", '\\_').gsub("$", '\\$')
end

def coauthors(pub)
  others = pub["authors"].reject { |a| a == SELF_NAME }.map { |a| tex_escape(a) }
  return "" if others.empty?
  list = others.size == 1 ? others.first : "#{others[0..-2].join(', ')}#{others.size > 2 ? ',' : ''} and #{others.last}"
  " [With #{list}]"
end

def journal_tex(pub)
  j = "\\textit{#{tex_escape(pub['journal'])}}"
  link = pub["doi"] ? "https://doi.org/#{pub['doi']}" : pub["url"]
  link ? "\\href{#{link}}{#{j}}" : j
end

def venue_numbers(pub)
  vol = pub["volume"]
  pages = pub["pages"]
  if vol
    s = ", #{vol}"
    s += "(#{pub['issue']})" if pub["issue"]
    s += ": #{tex_escape(pages)}" if pages
    s
  elsif pages
    ", #{tex_escape(pages)}" # FirstView 등 권호 미정 + 페이지만 있는 경우
  else
    ""
  end
end

def korean_mark(pub)
  pub["language"] == "ko" ? " (In Korean)" : ""
end

# 제목이 ?/!로 끝나면 마침표를 겹치지 않는다
def quoted_title(pub)
  t = tex_escape(pub["title"])
  "``#{t}#{t.end_with?("?", "!") ? '' : '.'}''"
end

def published_entry(pub)
  "\\hangindent=2em\n\\years{#{pub['year']}} #{quoted_title(pub)} " \
    "#{journal_tex(pub)}#{venue_numbers(pub)}#{korean_mark(pub)}#{coauthors(pub)}\\\\\n"
end

def forthcoming_entry(pub)
  "\\hangindent=2em\n\\years{Forthcoming} #{quoted_title(pub)} " \
    "#{journal_tex(pub)}#{korean_mark(pub)}#{coauthors(pub)}\\\\\n"
end

def under_review_entry(pub)
  "\\hangindent=2em\n#{quoted_title(pub)} " \
    "(Revise and Resubmit, #{journal_tex(pub)})#{coauthors(pub)} \\\\\n"
end

def plain_entry(pub)
  "\\hangindent=2em\n#{quoted_title(pub)}#{coauthors(pub)} \\\\\n"
end

# pillar 레이아웃용: 항목 단위 status 라벨
def rr_entry(pub)
  "\\hangindent=2em\n#{quoted_title(pub)} Revise and Resubmit, #{journal_tex(pub)}#{coauthors(pub)} \\\\\n"
end

def inreview_entry(pub)
  label = pub["journal"] ? "Under Review, #{journal_tex(pub)}" : "Under Review"
  "\\hangindent=2em\n#{quoted_title(pub)} #{label}#{coauthors(pub)} \\\\\n"
end

def pillar_item(pub)
  case pub["status"]
  when "published"    then published_entry(pub)
  when "forthcoming"  then forthcoming_entry(pub)
  when "under-review" then rr_entry(pub)
  when "in-review"    then inreview_entry(pub)
  end
end

STATUS_ORDER = { "forthcoming" => 0, "under-review" => 1, "in-review" => 2, "published" => 3 }.freeze

def pillar_sort(list)
  list.sort_by { |p| [STATUS_ORDER.fetch(p["status"], 9), -(p["year"] || 0).to_i] }
end

PILLARS = [
  ["business",   "Business, Interest Groups, and Economic Policymaking"],
  ["opinion",    "Public Opinion in Global Politics"],
  ["env-energy", "Political Economy of Environment and Energy"],
  ["other",      "Other Publications"],
].freeze

SUBGROUPS = [
  ["climate-accountability",      "Climate Politics and Electoral Accountability"],
  ["subsidies-social-contract",   "Subsidies, Taxation, and the Social Contract"],
  ["energy-access-reform",        "Energy Access and Power Sector Reform"],
  ["environment-trade-transition", "Environment, Trade, and the Low-Carbon Transition"],
].freeze

layout = "pillar"
ARGV.each { |a| layout = Regexp.last_match(1) if a =~ /\A--layout=(pillar|year)\z/ }

pubs = YAML.load_file(File.join(ROOT, "_data", "publications.yml"))
by = pubs.group_by { |p| p["status"] }

out = +"% ============================================================\n"
out << "% AUTO-GENERATED — 직접 수정 금지. (layout: #{layout})\n"
out << "% 소스: _data/publications.yml / 생성: ruby scripts/build-cv-publications.rb [--layout=pillar|year]\n"
out << "% ============================================================\n\n"

if layout == "year"
  out << "\\subsection*{Peer-Reviewed Articles}\n\n"
  (by["published"] || []).sort_by { |p| -p["year"].to_i }.each { |p| out << published_entry(p) << "\n" }

  out << "\\subsection*{Forthcoming}\n\n"
  (by["forthcoming"] || []).each { |p| out << forthcoming_entry(p) << "\n" }

  out << "\\subsection*{Under Review}\n\n"
  (by["under-review"] || []).each { |p| out << under_review_entry(p) << "\n" }
  (by["in-review"] || []).each { |p| out << plain_entry(p) << "\n" }
else
  non_wp = pubs.reject { |p| p["status"] == "working-paper" }
  PILLARS.each do |key, title|
    items = non_wp.select { |p| p["pillar"] == key }
    next if items.empty?
    out << "\\subsection*{#{title}}\n\n"
    if key == "env-energy"
      SUBGROUPS.each do |skey, stitle|
        sub = items.select { |p| p["subgroup"] == skey }
        next if sub.empty?
        out << "\\subsubsection*{#{stitle}}\n\n"
        pillar_sort(sub).each { |p| out << pillar_item(p) << "\n" }
      end
      orphans = items.reject { |p| SUBGROUPS.any? { |skey, _| p["subgroup"] == skey } }
      warn "WARN: env-energy without subgroup: #{orphans.map { |p| p['title'][0, 40] }}" unless orphans.empty?
    else
      pillar_sort(items).each { |p| out << pillar_item(p) << "\n" }
    end
  end
end

# Working Papers는 두 레이아웃 모두 맨 끝에 별도 유지
out << "\\subsection*{Working Papers}\n\n"
(by["working-paper"] || []).each { |p| out << plain_entry(p) << "\n" }

path = File.join(ROOT, "cv", "publications-generated.tex")
File.write(path, out)
counts = %w[published forthcoming under-review in-review working-paper].map { |k| "#{k}: #{(by[k] || []).size}" }
puts "wrote #{path} (layout=#{layout}; #{counts.join(', ')})"
