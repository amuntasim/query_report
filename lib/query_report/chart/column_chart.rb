require 'query_report/chart/themes'
require 'query_report/chart/chart_base'

module QueryReport
  module ColumnChartModule
    def column_chart(title, &block)
      chart = QueryReport::Chart::ColumnChart.new(title, self.filtered_query)
      chart.instance_eval &block if block_given?
      @charts ||= []
      @charts << chart
    end
  end

  module Chart
    class ColumnChart < QueryReport::Chart::ChartBase
      def initialize(title, query, options={})
        super(title, query, options)
      end

      def prepare_visualr
        @data_table = GoogleVisualr::DataTable.new

        ##### Adding column header #####
        @data_table.new_column('string', '')
        @columns.each do |col|
          @data_table.new_column(col.type.to_s, col.title)
        end
        ##### Adding column header #####

        @data_table.add_row([''] + @data)
        options = {:title => title, backgroundColor: 'transparent'}.merge(@options)
        GoogleVisualr::Interactive::ColumnChart.new(@data_table, options)
      end

      def to_blob
        super(:bar)
      end
    end
  end
end