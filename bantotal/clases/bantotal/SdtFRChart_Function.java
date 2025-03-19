package com.dlya.bantotal ;
import com.genexus.*;
import com.genexus.xml.*;

public final class SdtFRChart_Function extends GXXMLSerializable
{
   public SdtFRChart_Function( )
   {
      super(new ModelContext(SdtFRChart_Function.class), "SdtFRChart_Function");
   }

   public SdtFRChart_Function( ModelContext context )
   {
      super(context, "SdtFRChart_Function");
   }

   public short readxml( com.genexus.xml.XMLReader oReader )
   {
      short GXSoapError ;
      GXSoapError = (short)(1) ;
      sTagName = oReader.getName() ;
      GXSoapError = oReader.read() ;
      nOutParmCount = 0 ;
      while ( ( ( GXutil.strcmp(oReader.getName(), sTagName) != 0 ) || ( oReader.getNodeType() == 1 ) ) && ( GXSoapError > 0 ) )
      {
         readOk = 0 ;
         if ( ( GXutil.strcmp(oReader.getLocalName(), "Name") == 0 ) && ( ( GXutil.strcmp(oReader.getNamespaceURI(), "MIS_Web_Gx80") == 0 ) || ( GXutil.strcmp(oReader.getNamespaceURI(), "") == 0 ) ) )
         {
            gxTv_SdtFRChart_Function_Name = oReader.getValue() ;
            readOk = (short)(1) ;
         }
         if ( ( GXutil.strcmp(oReader.getLocalName(), "SourceSerie") == 0 ) && ( ( GXutil.strcmp(oReader.getNamespaceURI(), "MIS_Web_Gx80") == 0 ) || ( GXutil.strcmp(oReader.getNamespaceURI(), "") == 0 ) ) )
         {
            gxTv_SdtFRChart_Function_Sourceserie = oReader.getValue() ;
            readOk = (short)(1) ;
         }
         if ( ( GXutil.strcmp(oReader.getLocalName(), "AreaId") == 0 ) && ( ( GXutil.strcmp(oReader.getNamespaceURI(), "MIS_Web_Gx80") == 0 ) || ( GXutil.strcmp(oReader.getNamespaceURI(), "") == 0 ) ) )
         {
            gxTv_SdtFRChart_Function_Areaid = (byte)(GXutil.val( oReader.getValue())) ;
            readOk = (short)(1) ;
         }
         if ( ( GXutil.strcmp(oReader.getLocalName(), "Param1") == 0 ) && ( ( GXutil.strcmp(oReader.getNamespaceURI(), "MIS_Web_Gx80") == 0 ) || ( GXutil.strcmp(oReader.getNamespaceURI(), "") == 0 ) ) )
         {
            gxTv_SdtFRChart_Function_Param1 = GXutil.val( oReader.getValue()) ;
            readOk = (short)(1) ;
         }
         if ( ( GXutil.strcmp(oReader.getLocalName(), "Param2") == 0 ) && ( ( GXutil.strcmp(oReader.getNamespaceURI(), "MIS_Web_Gx80") == 0 ) || ( GXutil.strcmp(oReader.getNamespaceURI(), "") == 0 ) ) )
         {
            gxTv_SdtFRChart_Function_Param2 = GXutil.val( oReader.getValue()) ;
            readOk = (short)(1) ;
         }
         if ( ( GXutil.strcmp(oReader.getLocalName(), "Param3") == 0 ) && ( ( GXutil.strcmp(oReader.getNamespaceURI(), "MIS_Web_Gx80") == 0 ) || ( GXutil.strcmp(oReader.getNamespaceURI(), "") == 0 ) ) )
         {
            gxTv_SdtFRChart_Function_Param3 = GXutil.val( oReader.getValue()) ;
            readOk = (short)(1) ;
         }
         GXSoapError = oReader.read() ;
         nOutParmCount = (short)(nOutParmCount+1) ;
         if ( ( readOk == 0 ) )
         {
            GXSoapError = (short)(nOutParmCount*-1) ;
         }
      }
      return GXSoapError ;
   }

   public void writexml( com.genexus.xml.XMLWriter oWriter ,
                         String sName ,
                         String sNameSpace )
   {
      short GXSoapError ;
      if ( ! ((GXutil.strcmp("", GXutil.rtrim( sNameSpace))==0)) && ( GXutil.strcmp(sNameSpace, "MIS_Web_Gx80") != 0 ) )
      {
         oWriter.writeStartElement(sName+"ns:"+sName);
         oWriter.writeAttribute("xmlns:"+sName+"ns", sNameSpace);
      }
      else
      {
         oWriter.writeStartElement(sName);
      }
      if ( ((GXutil.strcmp("", GXutil.rtrim( sNameSpace))==0)) || ( GXutil.strcmp(sNameSpace, "MIS_Web_Gx80") != 0 ) )
      {
         oWriter.writeAttribute("xmlns", "MIS_Web_Gx80");
      }
      oWriter.writeElement("Name", GXutil.trim( gxTv_SdtFRChart_Function_Name));
      oWriter.writeElement("SourceSerie", GXutil.trim( gxTv_SdtFRChart_Function_Sourceserie));
      oWriter.writeElement("AreaId", GXutil.trim( GXutil.str( gxTv_SdtFRChart_Function_Areaid, 2, 0)));
      oWriter.writeElement("Param1", GXutil.trim( GXutil.str( gxTv_SdtFRChart_Function_Param1, 16, 4)));
      oWriter.writeElement("Param2", GXutil.trim( GXutil.str( gxTv_SdtFRChart_Function_Param2, 16, 4)));
      oWriter.writeElement("Param3", GXutil.trim( GXutil.str( gxTv_SdtFRChart_Function_Param3, 16, 4)));
      oWriter.writeEndElement();
      return  ;
   }

   public String getgxTv_SdtFRChart_Function_Name( )
   {
      return gxTv_SdtFRChart_Function_Name ;
   }

   public void setgxTv_SdtFRChart_Function_Name( String value )
   {
      gxTv_SdtFRChart_Function_Name = value ;
      return  ;
   }

   public String getgxTv_SdtFRChart_Function_Sourceserie( )
   {
      return gxTv_SdtFRChart_Function_Sourceserie ;
   }

   public void setgxTv_SdtFRChart_Function_Sourceserie( String value )
   {
      gxTv_SdtFRChart_Function_Sourceserie = value ;
      return  ;
   }

   public byte getgxTv_SdtFRChart_Function_Areaid( )
   {
      return gxTv_SdtFRChart_Function_Areaid ;
   }

   public void setgxTv_SdtFRChart_Function_Areaid( byte value )
   {
      gxTv_SdtFRChart_Function_Areaid = value ;
      return  ;
   }

   public double getgxTv_SdtFRChart_Function_Param1( )
   {
      return gxTv_SdtFRChart_Function_Param1 ;
   }

   public void setgxTv_SdtFRChart_Function_Param1( double value )
   {
      gxTv_SdtFRChart_Function_Param1 = value ;
      return  ;
   }

   public double getgxTv_SdtFRChart_Function_Param2( )
   {
      return gxTv_SdtFRChart_Function_Param2 ;
   }

   public void setgxTv_SdtFRChart_Function_Param2( double value )
   {
      gxTv_SdtFRChart_Function_Param2 = value ;
      return  ;
   }

   public double getgxTv_SdtFRChart_Function_Param3( )
   {
      return gxTv_SdtFRChart_Function_Param3 ;
   }

   public void setgxTv_SdtFRChart_Function_Param3( double value )
   {
      gxTv_SdtFRChart_Function_Param3 = value ;
      return  ;
   }

   public void initialize( )
   {
      gxTv_SdtFRChart_Function_Name = "" ;
      gxTv_SdtFRChart_Function_Sourceserie = "" ;
      gxTv_SdtFRChart_Function_Areaid = 0 ;
      gxTv_SdtFRChart_Function_Param1 = 0 ;
      gxTv_SdtFRChart_Function_Param2 = 0 ;
      gxTv_SdtFRChart_Function_Param3 = 0 ;
      sTagName = "" ;
      nOutParmCount = 0 ;
      readOk = 0 ;
      GXt_char7 = "" ;
      return  ;
   }

   public SdtFRChart_Function Clone( )
   {
      return (SdtFRChart_Function)(clone()) ;
   }

   private byte gxTv_SdtFRChart_Function_Areaid ;
   private short nOutParmCount ;
   private short readOk ;
   private double gxTv_SdtFRChart_Function_Param1 ;
   private double gxTv_SdtFRChart_Function_Param2 ;
   private double gxTv_SdtFRChart_Function_Param3 ;
   private String sTagName ;
   private String GXt_char7 ;
   private String gxTv_SdtFRChart_Function_Name ;
   private String gxTv_SdtFRChart_Function_Sourceserie ;
}

