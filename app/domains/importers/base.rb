module Importers
  class Base < Struct.new(:csv_file_path, keyword_init: true)
    protected

    def records = mapper_class.from_csv(csv_content, headers: true, col_sep: ";")

    def mapper_class
      raise NotImplementedError
    end

    def csv_content = ::File.read(csv_file_path)
  end
end
