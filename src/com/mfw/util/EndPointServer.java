package com.mfw.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.google.gson.Gson;
import com.mfw.service.system.menu.MenuService;
import com.mfw.service.system.user.UserService;
import com.mfw.util.mail.SimpleMailSender;

@ServerEndpoint("/task/msg")
public class EndPointServer {
	
	private static UserService userService;
	private static MenuService menuService;
	private static Set<Session> sessions = new HashSet<>();
	private static Properties properties = new Properties();
	private static InputStream inputStream;
	
	static{
		try {
			inputStream = UserService.class.getClassLoader().getResourceAsStream("message_zh_CN.properties");
			properties.load(new InputStreamReader(inputStream, "UTF-8"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@OnOpen
	public void onOpen(Session session){
		sessions.add(session);
	}
	
	@OnMessage
	public void onMessage(String message){
		System.out.println(message);
	}
	
	@OnClose
	public void onClose(Session session){
		sessions.remove(session);
	}

	/**
	 * 发送消息
	 * @param targetEmpCode	目标员工编号
	 * @param type	任务类型
	 * @throws Exception
	 */
	public static void sendMessage(String sendMsgUserName, String targetEmpCode, TaskType type) throws Exception{
		PageData pd = new PageData();
		pd.put("NUMBER", targetEmpCode);
		pd = userService.findByUN(pd);
		for(Session session : sessions){
			String msgText = sendMsgUserName + " "+ properties.getProperty(Const.WEBSOCKET_MSG_PREFFIX + type.toString());
			if(pd != null && session.getUserPrincipal().getName().equals(pd.get("USERNAME").toString())){
				String url = properties.getProperty(Const.WEBSOCKET_URL_PREFFIX + type.toString());
				String[] urls = url.split("\\?");
				
				PageData result = new PageData();
				result = menuService.findByUrl(urls[0]);
				result.put("MENU_URL", url);
				result.put("taskMsg",msgText );
				session.getBasicRemote().sendText(new Gson().toJson(result));
			}else if(pd != null && pd.get("EMAIL") != null){
				SimpleMailSender.simpleSendEmail(pd.get("EMAIL").toString(), "工作", msgText);
			}
		}
	}

	public static UserService getUserService() {
		return userService;
	}

	public static void setUserService(UserService userService) {
		EndPointServer.userService = userService;
	}

	public static MenuService getMenuService() {
		return menuService;
	}

	public static void setMenuService(MenuService menuService) {
		EndPointServer.menuService = menuService;
	}
	
}
