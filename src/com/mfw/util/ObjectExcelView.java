package com.mfw.util;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.Region;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import com.mfw.util.PageData;
import com.mfw.util.Tools;

/**
 * 导入到EXCEL 类名称：ObjectExcelView.java 类描述：
 * 
 * @author mfw 作者单位： 联系方式：
 * @version 1.0
 */
public class ObjectExcelView extends AbstractExcelView {

	@Override
	protected void buildExcelDocument(Map<String, Object> model, HSSFWorkbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub
		Date date = new Date();
		String filename = Tools.date2Str(date, "yyyyMMddHHmmss");
		HSSFSheet sheet;
		HSSFCell cell;
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment;filename=" + filename + ".xls");
		sheet = workbook.createSheet("sheet1");

		List<String> titles = (List<String>) model.get("titles");
		int len = titles.size();
		
		HSSFCellStyle headerStyle = workbook.createCellStyle(); //标题样式
		headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		headerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
//		headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
//		headerStyle.setFillForegroundColor(HSSFColor.ROYAL_BLUE.index);
		HSSFFont headerFont = workbook.createFont(); //标题字体
		headerFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		headerFont.setFontHeightInPoints((short) 16);
		headerFont.setFontName("宋体");
//		headerFont.setColor(HSSFColor.WHITE.index);
		headerStyle.setFont(headerFont);
		
		HSSFCellStyle titleStyle = workbook.createCellStyle(); //行标题样式
		titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		titleStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		HSSFFont titleFont = workbook.createFont(); //内容字体
		titleFont.setFontHeightInPoints((short) 11);
		titleFont.setFontName("宋体");
		titleStyle.setFont(titleFont);
		
		HSSFCellStyle contentStyle = workbook.createCellStyle(); //内容样式
		contentStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		HSSFFont contentFont = workbook.createFont(); //内容字体
		contentFont.setFontName("宋体");
		contentStyle.setFont(contentFont);
		
		short width = 20, height = 25 * 20;
		sheet.setDefaultColumnWidth(width);
		int currentRow = 0;
		//设置文件第一行标题
		if(null != model.get("fileTile")){
			sheet.addMergedRegion(new Region(0, (short)0, 0, (short)(len-1)));
			cell = getCell(sheet, 0, 0);
			cell.setCellStyle(headerStyle);
			setText(cell, model.get("fileTile").toString());
			sheet.getRow(currentRow).setHeight(height);
			currentRow ++;
		}
		if(len>0){
			for (int i = 0; i < len; i++) { //设置标题
				String title = titles.get(i);
				cell = getCell(sheet, currentRow, i);
				cell.setCellStyle(titleStyle);
				setText(cell, title);
			}
			sheet.getRow(currentRow).setHeight(height);
			currentRow ++;
		}
		//读取数据行
		List<PageData> varList = (List<PageData>) model.get("varList");
		int varCount = varList.size();
		for (int i = 0; i < varCount; i++) {
			PageData vpd = varList.get(i);
			for (int j = 0; j < len; j++) {
				String varstr = vpd.getString("var" + (j + 1)) != null ? vpd.getString("var" + (j + 1)) : "";
				cell = getCell(sheet, i + currentRow, j);
				cell.setCellStyle(contentStyle);
				setText(cell, varstr);
			}

		}

	}

}
