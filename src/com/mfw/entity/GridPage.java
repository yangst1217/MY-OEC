package com.mfw.entity;

import java.util.List;

import com.mfw.util.PageData;

/**
 * Grid分页对象
 * @author 李伟涛
 *
 */
public class GridPage {

	/**
	 * 列表数据
	 */
	private List<PageData> rows;
	/**
	 * 当前页
	 */
	private Integer current;
	/**
	 * 每页条数
	 */
	private Integer rowCount;
	/**
	 * 总数据条数
	 */
	private Integer total;
	
	public GridPage(List<PageData> rows, Page page){
		super();
		this.rows = rows;
		this.current = page.getCurrentPage();
		this.rowCount = page.getShowCount();
		this.total = page.getTotalResult();
	}
	
	public GridPage(List<PageData> rows, Page page, Integer total){
		super();
		this.rows = rows;
		this.current = page.getCurrentPage();
		this.rowCount = page.getShowCount();
		this.total = total;
	}
	
	public GridPage(List<PageData> rows, Integer current, Integer rowCount, Integer total) {
		super();
		this.rows = rows;
		this.current = current;
		this.rowCount = rowCount;
		this.total = total;
	}

	/*Getters And Setters*/
	public List<PageData> getRows() {
		return rows;
	}

	public void setRows(List<PageData> rows) {
		this.rows = rows;
	}

	public Integer getCurrent() {
		return current;
	}

	public void setCurrent(Integer current) {
		this.current = current;
	}

	public Integer getRowCount() {
		return rowCount;
	}

	public void setRowCount(Integer rowCount) {
		this.rowCount = rowCount;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}
}
