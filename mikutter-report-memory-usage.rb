# -*- coding: utf-8 -*-

Plugin.create :"mikutter-report-memory-usage" do
  def report_memory_usage ()
    usage = `ps -o rss= -p #{$$}`.to_i
    if usage < 1024 then
      str = sprintf("%dKB", usage)
    else
      usage /= 1024.0
      if usage < 1024 then
        str = sprintf("%.2fMB", usage)
      else
        usage /= 1024.0
        str = sprintf("%.2fGB", usage)
      end
    end
    activity :system, "mikutterのメモリ使用量: " + str
    Reserver.new (UserConfig[:"report-memory-usage-interval"]) {
      report_memory_usage
    }
  end

  on_boot do |service|
    UserConfig[:"report-memory-usage-interval"] ||= 300
    report_memory_usage
  end

  settings "メモリ使用量報告" do
    begin
      adjustment("メモリ使用量報告間隔(s)", :"report-memory-usage-interval", 1, 3600)
    rescue => e
      puts e
      puts e.backtrace
    end
  end
end

