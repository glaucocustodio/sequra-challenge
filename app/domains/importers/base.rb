require "csv"

module Importers
  class Base < Struct.new(:csv_file_path, keyword_init: true)
    protected

    def records
      CSV.foreach(csv_file_path, headers: true, col_sep: ";").lazy.map do |row|
        mapper_class.new(**row.to_h.transform_keys(&:to_sym))
      end
    end

    def mapper_class
      raise NotImplementedError
    end
  end
end
