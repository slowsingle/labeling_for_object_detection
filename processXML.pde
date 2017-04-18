String stationery_path = "xml/stationery.xml";
String object_path = "xml/object.xml";

class DataXML{
  XML stationery_xml;
  DataXML(String imgFileName, int imgWidth, int imgHeight){
    stationery_xml = loadXML(stationery_path);
    stationery_xml.getChild("filename").setContent(imgFileName);
    stationery_xml.getChild("size").getChild("width").setContent(str(imgWidth));
    stationery_xml.getChild("size").getChild("height").setContent(str(imgHeight));
  }
  
  void addData(String obj_name, int xmin, int ymin, int xmax, int ymax){
    XML add_xml = loadXML(object_path);
    add_xml.getChild("name").setContent(obj_name);
    add_xml.getChild("bndbox").getChild("xmin").setContent(str(xmin));
    add_xml.getChild("bndbox").getChild("ymin").setContent(str(ymin));
    add_xml.getChild("bndbox").getChild("xmax").setContent(str(xmax));
    add_xml.getChild("bndbox").getChild("ymax").setContent(str(ymax));
    stationery_xml.addChild(add_xml);
  }
  
  void saveNewXML(String filename){
    saveXML(stationery_xml, filename);
  }
}