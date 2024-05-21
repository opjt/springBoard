package com.spring.user.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.HomeController;
import com.spring.board.vo.BoardVo;
import com.spring.board.vo.PageVo;
import com.spring.common.CommonUtil;
import com.spring.common.vo.CodeVo;
import com.spring.user.service.UserService;
import com.spring.user.vo.UserVo;

@Controller
public class UserController {
	
	@Autowired
	UserService userService;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/user/login.do", method = RequestMethod.GET)
	public String userLogin(Locale locale, Model model) throws Exception{
	
		return "user/login";
	}
	@RequestMapping(value = "/user/logout.do", method = RequestMethod.GET)
	public String userLogout(HttpServletRequest request) {
        HttpSession session = request.getSession();
        session.invalidate();
        return "redirect:/board/boardList.do";
    }
	
	@RequestMapping(value = "/user/join.do", method = RequestMethod.GET)
	public String userJoin(Locale locale, Model model) throws Exception{
	
		List<CodeVo> codeList = userService.selectCodeList();
		model.addAttribute("codeList", codeList);
		
		return "user/join";
	}
	@RequestMapping(value = "/user/joinAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String userJoinAction(Locale locale,UserVo userVo) throws Exception{
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		int resultCnt = userService.userJoin(userVo);
		
		result.put("success", (resultCnt > 0)?"Y":"N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	@RequestMapping(value = "/user/loginAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String userLoginAction(Locale locale,UserVo userVo, HttpServletRequest request) throws Exception{
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		UserVo loginUser = userService.userLogin(userVo);
		
		result.put("success", (loginUser != null)?"Y":"N");
		if(loginUser != null ) {
			HttpSession session = request.getSession();
	        session.setAttribute("user",loginUser);	
		}
		
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	
	@RequestMapping(value = "/user/checkIdAction.do", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, String> userCheckId(Locale locale, HttpServletRequest request,@RequestParam("userId") String userId) throws Exception{
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		UserVo checkUser = userService.userCheckId(userId);
		
		result.put("result", (checkUser == null)?"Y":"N");
		
		
		return result;
	}

}
