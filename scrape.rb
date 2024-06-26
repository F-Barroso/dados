require 'watir'
require 'csv'

client = Selenium::WebDriver::Remote::Http::Default.new
browser = Watir::Browser.new :chrome, http_client: client
position = browser.window.move_to 1400, 0
browser.goto 'https://www.legislativas2024.mai.gov.pt/resultados/territorio-nacional'
browser.link(text: 'Localidades').click

col_sep = '|'

distrito = browser.select_lists(aria_label: 'Distrito/Região Autónoma')
a = []
distrito.each { |e| a << e.innertext }
distritos = a[0].to_s.split(/\n+/).drop(1)

distritos.each do |d|
  distrito[0].wait_until(&:present?).select(text: 'Açores')#.select(text: d)
  # puts browser.h1.text
  # puts browser.h2.text
  concelho = browser.select_lists(aria_label: 'Concelho')
  sleep 1
  a_two = []
  concelho.each { |e| a_two << e.innertext }
  concelhos = a_two[0].to_s.split(/\n+/).drop(1)
  concelhos
  sleep 2
  concelhos.each do |c|
    # puts browser.h1.text
    # puts browser.h2.text
    concelho[0].wait_until(&:present?).select(text: c)
    freguesia = browser.select_lists(aria_label: 'Freguesia')
    sleep 1
    a = []
    freguesia.each { |e| a << e.innertext }
    freguesias = a[0].to_s.split(/\n+/).drop(1)
    # freguesias.each {|f| puts "#{d}|#{c}|#{f}" }
    sleep 1
    freguesias.each do |f|
      freguesia[0].wait_until(&:present?).select(text: f)
      sleep 2
      div = browser.div(class: 'small-text')
      i = div.spans[1].text.gsub('inscritos', '').gsub(/\s+/, '')
      rows = browser.divs(class: 'chart-row')
      row_arr = []
      rows.each { |td| row_arr << td.text.to_s.gsub("\n", ' | ') }
      content = row_arr.reject(&:empty?).join(', ').gsub('votos, ', '| ')
      content = content.gsub(/\s+/, '').gsub('votos', '').split('|')
      total = "#{d}|#{c}|#{f}|#{i}|#{content}"
      CSV.open('table.csv', 'a+', col_sep: col_sep,
                                  headers: %w[Distrito Concelho Freguesia Partido Inscritos Voto(%) Votos]) do |csv|
        csv << [d.to_s, c.to_s, f.to_s, i.to_s].push(*content)
      end
      # File.open('table.csv', 'w') { |file| file.puts "#{d}|#{c}|#{f}|#{content}" }
    end
  end
end
browser.close

# distrito = distrito
# concelho = browser.select_lists(aria_label: "Concelho")
# concelho = concelho.drop(1)
# freguesia = browser.select_lists(aria_label: "Freguesia")
# freguesia = freguesia.drop(1)

# rows = browser.divs(class:"chart-row")
# row_arr = []
# rows.each {|td|  row_arr << td.text}
# row_arr.each {|e| e.to_s.gsub("\n", ", ")}
