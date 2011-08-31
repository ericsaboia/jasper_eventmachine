include Java

JASPER_DIR = File.expand_path("")+"/lib/jasper/" 

Dir.entries(JASPER_DIR).each do |lib|
  require JASPER_DIR+lib if lib =~ /\.jar$/
end

Dir.entries(JASPER_DIR+"lib/").each do |lib|
  require JASPER_DIR+"lib/#{lib}" if lib =~ /\.jar$/
end

java_import Java::net::sf::jasperreports::engine::data::JRBeanCollectionDataSource
java_import Java::net::sf::jasperreports::engine::util::JRXmlUtils
java_import Java::net::sf::jasperreports::engine::query::JRXPathQueryExecuterFactory
java_import Java::net::sf::jasperreports::engine::JasperFillManager
java_import Java::net::sf::jasperreports::engine::JasperExportManager
java_import Java::net::sf::jasperreports::engine::JRExporterParameter
java_import Java::org::xml::sax::InputSource
java_import Java::java::io::StringReader
java_import Java::java::util::ArrayList
