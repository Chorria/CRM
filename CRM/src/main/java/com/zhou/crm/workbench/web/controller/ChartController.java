package com.zhou.crm.workbench.web.controller;

import com.zhou.crm.workbench.service.ActivityService;
import com.zhou.crm.workbench.service.ClueService;
import com.zhou.crm.workbench.service.ContactsService;
import com.zhou.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ChartController {
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private TransactionService transactionService;

    @RequestMapping("/workbench/chart/activity/index.do")
    public String activityIndex(){
        return "workbench/chart/activity/index";
    }

    @RequestMapping("/workbench/chart/queryCountOfActivityGroupByName.do")
    public @ResponseBody Object queryCountOfActivityGroupByName(){
        return activityService.queryCountOfActivityGroupByName();
    }

    @RequestMapping("/workbench/chart/clue/index.do")
    public String clueIndex(){
        return "workbench/chart/clue/index";
    }

    @RequestMapping("/workbench/chart/queryCountOfClueGroupBySource.do")
    public @ResponseBody Object queryCountOfClueGroupByCSource(){
        return clueService.queryCountOfClueGroupBySource();
    }

    @RequestMapping("/workbench/chart/customerAndContacts/index.do")
    public String customerAndContactsIndex(){
        return "workbench/chart/customerAndContacts/index";
    }

    @RequestMapping("/workbench/chart/queryCountOfCustomerAndContactsGroupByCustomerId.do")
    public @ResponseBody Object queryCountOfCustomerAndContactsGroupByCustomerId(){
        return contactsService.queryCountOfContactsGroupByCustomerId();
    }

    @RequestMapping("/workbench/chart/transaction/index.do")
    public String transactionIndex(){
        return "workbench/chart/transaction/index";
    }

    @RequestMapping("/workbench/chart/queryCountOfTransactionGroupByStage.do")
    public @ResponseBody Object queryCountOfTransactionGroupByStage(){
        return transactionService.queryCountOfTransactionGroupByStage();
    }
}
