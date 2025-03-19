package com.dlya.bantotal ;
import com.genexus.*;
import com.genexus.xml.*;

public final class SdtFRChart_Serie_Element extends GXXMLSerializable
{
   public SdtFRChart_Serie_Element( )
   {
      super(new ModelContext(SdtFRChart_Serie_Element.class), "SdtFRChart_Serie_Element");
   }

   public SdtFRChart_Serie_Element( ModelContext context )
   {
      super(context, "SdtFRChart_Serie_Element");
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
         if ( ( GXutil.strcmp(oReader.getLocalName(), "Id") == 0 ) && ( ( GXutil.strcmp(oReader.getNamespaceURI(), "MIS_Web_Gx80") == 0 ) || ( GXutil.strcmp(oReader.getNamespaceURI(), "") == 0 ) ) )
         {
            gxTv_SdtFRChart_Serie_Element_Id = oReader.getValue() ;
            readOk = (short)(1) ;
         }
         if ( ( GXutil.strcmp(oReader.getLocalName(), "XDate") == 0 ) && ( ( GXutil.strcmp(oReader.getNamespaceURI(), "MIS_Web_Gx80") == 0 ) || ( GXutil.strcmp(oReader.getNamespaceURI(), "") == 0 ) ) )
         {
            if ( ( GXutil.strcmp(oReader.getValue(), "0000-00-00T00:00:00") == 0 ) )
            {
               gxTv_SdtFRChart_Serie_Element_Xdate = GXutil.resetTime( GXutil.nullDate() );
            }
            else
            {
               gxTv_SdtFRChart_Serie_Element_Xdate = localUtil.ymdhmsToT( (short)(GXutil.val( GXutil.substring( oReader.getValue(), 1, 4))), (byte)(GXutil.val( GXutil.substring( oReader.getValue(), 6, 2))), (byte)(GXutil.val( GXutil.substring( oReader.getValue(), 9, 2))), (byte)(GXutil.val( GXutil.substring( oReader.getValue(), 12, 2))), (byte)(GXutil.val( GXutil.substring( oReader.getValue(), 15, 2))), (byte)(GXutil.val( GXutil.substring( oReader.getValue(), 18, 2)))) ;
            }
            readOk = (short)(1) ;
         }
         if ( ( GXutil.strcmp(oReader.getLocalName(), "XValue") == 0 ) && ( ( GXutil.strcmp(oReader.getNamespaceURI(), "MIS_Web_Gx80") == 0 ) || ( GXutil.strcmp(oReader.getNamespaceURI(), "") == 0 ) ) )
         {
            gxTv_SdtFRChart_Serie_Element_Xvalue = GXutil.val( oReader.getValue()) ;
            readOk = (short)(1) ;
         }
         if ( ( GXutil.strcmp(oReader.getLocalName(), "YValue") == 0 ) && ( ( GXutil.strcmp(oReader.getNamespaceURI(), "MIS_Web_Gx80") == 0 ) || ( GXutil.strcmp(oReader.getNamespaceURI(), "") == 0 ) ) )
         {
            gxTv_SdtFRChart_Serie_Element_Yvalue = GXutil.val( oReader.getValue()) ;
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
      oWriter.writeElement("Id", GXutil.trim( gxTv_SdtFRChart_Serie_Element_Id));
      if ( (GXutil.nullDate().equals(gxTv_SdtFRChart_Serie_Element_Xdate)) )
      {
         oWriter.writeElement("XDate", "0000-00-00T00:00:00");
      }
      else
      {
         sDateCnv = "" ;
         sNumToPad = GXutil.trim( GXutil.str( GXutil.year( gxTv_SdtFRChart_Serie_Element_Xdate), 10, 0)) ;
         sDateCnv = sDateCnv + GXutil.substring( "0000", 1, 4-sNumToPad.length( )) + sNumToPad ;
         sDateCnv = sDateCnv + "-" ;
         sNumToPad = GXutil.trim( GXutil.str( GXutil.month( gxTv_SdtFRChart_Serie_Element_Xdate), 10, 0)) ;
         sDateCnv = sDateCnv + GXutil.substring( "00", 1, 2-sNumToPad.length( )) + sNumToPad ;
         sDateCnv = sDateCnv + "-" ;
         sNumToPad = GXutil.trim( GXutil.str( GXutil.day( gxTv_SdtFRChart_Serie_Element_Xdate), 10, 0)) ;
         sDateCnv = sDateCnv + GXutil.substring( "00", 1, 2-sNumToPad.length( )) + sNumToPad ;
         sDateCnv = sDateCnv + "T" ;
         sNumToPad = GXutil.trim( GXutil.str( GXutil.hour( gxTv_SdtFRChart_Serie_Element_Xdate), 10, 0)) ;
         sDateCnv = sDateCnv + GXutil.substring( "00", 1, 2-sNumToPad.length( )) + sNumToPad ;
         sDateCnv = sDateCnv + ":" ;
         sNumToPad = GXutil.trim( GXutil.str( GXutil.minute( gxTv_SdtFRChart_Serie_Element_Xdate), 10, 0)) ;
         sDateCnv = sDateCnv + GXutil.substring( "00", 1, 2-sNumToPad.length( )) + sNumToPad ;
         sDateCnv = sDateCnv + ":" ;
         sNumToPad = GXutil.trim( GXutil.str( GXutil.second( gxTv_SdtFRChart_Serie_Element_Xdate), 10, 0)) ;
         sDateCnv = sDateCnv + GXutil.substring( "00", 1, 2-sNumToPad.length( )) + sNumToPad ;
         oWriter.writeElement("XDate", sDateCnv);
      }
      oWriter.writeElement("XValue", GXutil.trim( GXutil.str( gxTv_SdtFRChart_Serie_Element_Xvalue, 16, 4)));
      oWriter.writeElement("YValue", GXutil.trim( GXutil.str( gxTv_SdtFRChart_Serie_Element_Yvalue, 16, 4)));
      oWriter.writeEndElement();
      return  ;
   }

   public String getgxTv_SdtFRChart_Serie_Element_Id( )
   {
      return gxTv_SdtFRChart_Serie_Element_Id ;
   }

   public void setgxTv_SdtFRChart_Serie_Element_Id( String value )
   {
      gxTv_SdtFRChart_Serie_Element_Id = value ;
      return  ;
   }

   public java.util.Date getgxTv_SdtFRChart_Serie_Element_Xdate( )
   {
      return gxTv_SdtFRChart_Serie_Element_Xdate ;
   }

   public void setgxTv_SdtFRChart_Serie_Element_Xdate( java.util.Date value )
   {
      gxTv_SdtFRChart_Serie_Element_Xdate = value ;
      return  ;
   }

   public double getgxTv_SdtFRChart_Serie_Element_Xvalue( )
   {
      return gxTv_SdtFRChart_Serie_Element_Xvalue ;
   }

   public void setgxTv_SdtFRChart_Serie_Element_Xvalue( double value )
   {
      gxTv_SdtFRChart_Serie_Element_Xvalue = value ;
      return  ;
   }

   public double getgxTv_SdtFRChart_Serie_Element_Yvalue( )
   {
      return gxTv_SdtFRChart_Serie_Element_Yvalue ;
   }

   public void setgxTv_SdtFRChart_Serie_Element_Yvalue( double value )
   {
      gxTv_SdtFRChart_Serie_Element_Yvalue = value ;
      return  ;
   }

   public void initialize( )
   {
      gxTv_SdtFRChart_Serie_Element_Id = "" ;
      gxTv_SdtFRChart_Serie_Element_Xdate = GXutil.resetTime( GXutil.nullDate() );
      gxTv_SdtFRChart_Serie_Element_Xvalue = 0 ;
      gxTv_SdtFRChart_Serie_Element_Yvalue = 0 ;
      sTagName = "" ;
      nOutParmCount = 0 ;
      readOk = 0 ;
      GXt_char4 = "" ;
      sDateCnv = "" ;
      sNumToPad = "" ;
      return  ;
   }

   public SdtFRChart_Serie_Element Clone( )
   {
      return (SdtFRChart_Serie_Element)(clone()) ;
   }

   private short nOutParmCount ;
   private short readOk ;
   private double gxTv_SdtFRChart_Serie_Element_Xvalue ;
   private double gxTv_SdtFRChart_Serie_Element_Yvalue ;
   private String sTagName ;
   private String GXt_char4 ;
   private String sDateCnv ;
   private String sNumToPad ;
   private java.util.Date gxTv_SdtFRChart_Serie_Element_Xdate ;
   private String gxTv_SdtFRChart_Serie_Element_Id ;
}

