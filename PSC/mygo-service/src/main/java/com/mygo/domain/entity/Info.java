package com.mygo.domain.entity;

import java.util.List;
import lombok.Data;

@Data
public class Info {

    private String title;
    private String qualification;
    private List<String> expertise;
    private String introduction;

}
