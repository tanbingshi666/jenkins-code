package com.tanbs.devops.web;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

@RestController
@RequestMapping("/devops")
public class DevOpsController {

    @GetMapping("/hello")
    public String devops(){
        return (new Date().toString()) +"\t hello devops...";
    }

}
