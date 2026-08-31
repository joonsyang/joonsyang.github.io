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
  return "" unless vol
  s = ", #{vol}"
  s += "(#{pub['issue']})" if pub["issue"]
  s += ": #{tex_escape(pub['pages'])}" if pub["pages"]
  s
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

pubs = YAML.load_file(File.join(ROOT, "_data", "publications.yml"))
by = pubs.group_by { |p| p["status"] }

out = +"% ============================================================\n"
out << "% AUTO-GENERATED — 직접 수정 금지.\n"
out << "% 소스: _data/publications.yml / 생성: ruby scripts/build-cv-publications.rb\n"
out << "% ============================================================\n\n"

out << "\\subsection*{Peer-Reviewed Articles}\n\n"
(by["published"] || []).sort_by { |p| -p["year"].to_i }.each { |p| out << published_entry(p) << "\n" }

out << "\\subsection*{Forthcoming}\n\n"
(by["forthcoming"] || []).each { |p| out << forthcoming_entry(p) << "\n" }

out << "\\subsection*{Under Review}\n\n"
(by["under-review"] || []).each { |p| out << under_review_entry(p) << "\n" }
(by["in-review"] || []).each { |p| out << plain_entry(p) << "\n" }

out << "\\subsection*{Working Papers}\n\n"
(by["working-paper"] || []).each { |p| out << plain_entry(p) << "\n" }

path = File.join(ROOT, "cv", "publications-generated.tex")
File.write(path, out)
counts = %w[published forthcoming under-review in-review working-paper].map { |k| "#{k}: #{(by[k] || []).size}" }
puts "wrote #{path} (#{counts.join(', ')})"
