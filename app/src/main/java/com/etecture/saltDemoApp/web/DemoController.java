package com.etecture.saltDemoApp.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.net.InetAddress;
import java.net.UnknownHostException;

/**
 * Created by manuel on 09.10.15.
 */
@Controller
@RequestMapping
public class DemoController {

    @RequestMapping("/")
    public String index(Model model) throws UnknownHostException {

        model.addAttribute("hostname", InetAddress.getLocalHost().getCanonicalHostName());

        return "index";
    }

}
