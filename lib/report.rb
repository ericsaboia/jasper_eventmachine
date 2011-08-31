# encoding: utf-8

require 'lib/initializers'

class Report
  def initialize(args = {})
    @modelo = "#{args['path']}#{args['jasper']}.jasper"

    raise ArgumentError, "Arquivo #@modelo não existe." unless File.exist?(@modelo)

		jr_xml = JRXmlUtils.parse(
      org.xml.sax.InputSource.new(
        java.io.StringReader.new(args['xml'])
      )
    )
    
    @xml_document = Java::NetSfJasperreportsEngineData::JRXmlDataSource.new(jr_xml, args['xml_xpath'])

    @params = args['parametros']
  end

	def to_pdf
		fill = JasperFillManager.fill_report(@modelo, @params, @xml_document)  
		pdf = JasperExportManager.export_report_to_pdf(fill)  

		return String.from_java_bytes(pdf)
	end 

  require 'irb'

  def to_xls
    exportar_formato Java::net.sf.jasperreports.engine.export.JRXlsExporter.new
  end

  def to_csv
    exportar_formato Java::net.sf.jasperreports.engine.export.JRCsvExporter.new
  end

  def to_docx
    exportar_formato Java::net.sf.jasperreports.engine.export.ooxml.JRDocxExporter.new
  end

  def to_odt
    exportar_formato Java::net.sf.jasperreports.engine.export.oasis.JROdtExporter
  end

  def to_ods
    exportar_formato Java::net.sf.jasperreports.engine.export.oasis.JROdsExporter
  end

  def to_rtf
    exportar_formato Java::net.sf.jasperreports.engine.export.JRRtfExporter
  end

  private
  def exportar_formato(classe)
    fill = JasperFillManager.fill_report(@modelo, @params)
    string = java.io.ByteArrayOutputStream.new

    exporter = if classe.is_a?(Class) then classe.new else classe end

    exporter.set_parameter(JRExporterParameter::JASPER_PRINT, fill)
    exporter.set_parameter(JRExporterParameter::OUTPUT_STREAM, string)

    exporter.export_report
    return String.from_java_bytes(string.to_byte_array)
  end
end

