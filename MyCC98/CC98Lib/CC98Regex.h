//
//  CC98Regex.h
//  MyCC98
//
//  Created by Jason Chen on 6/10/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#define TODAY_BOARD_ENTITY_REGEX @"list\\.asp\\?boardid=.*?</td></tr>"
#define TODAY_POST_NUMBER_REGEX @"(?<=今日帖数：)\\d*?(?= )"
#define TODAY_BOARD_ID_REGEX @"(?<=boardid=).*?(?=\">)"
#define TODAY_BOARD_NAME_REGEX  @"(?<=\">).*?(?=</a></td><td)"
#define TODAY_BOARD_TOPIC_NUM_REGEX @"(?<=align=center>)\\d{0,10}?(?=</td>)"

#define P_BOARD_SINGLE_BOARD_WRAPPER_REGEX @"<!--版面名字-->.*?</table>"
#define P_BOARD_NAME_REGEX @"(?<=<font color=\"#000066\">).*?(?=</font></a>)"
#define P_BOARD_ID_REGEX @"(?<=<a href=\"list.asp\\?boardid=)[0-9]+(?=\">)"

#define POST_CONTENT_INFO_REGEX @"(?<=<title>).*?(?=&raquo;)|(?<=&page=\\d{1,5}>).+?(?=</a>)|(?<=本主题贴数 <b>).{0,10}?(?=</b>)"

#define P_BOARD_OUTER_WRAAPER_REGEX @"var customboards_disp = new Array[\\s\\S]*var customboards_order=customboards\\.split"

#define POST_LIST_POST_TYPE_REGEX @"(?<=alt=).*?(?=></TD>)"
#define POST_LIST_POST_NAME_REGEX @"(?<=最后跟贴：\">).*?(?=</a>)"
#define POST_LIST_POST_ID_REGEX @"(?<=&ID=)\\d{1,10}?(?=&page=)"
#define POST_LIST_POST_BOARD_ID_REGEX @"(?<=dispbbs.asp\\?boardID=)\\d{1,10}?(?=&ID=)"
#define POST_LIST_POST_PAGE_NUMBER_REGEX @"(?<=<font color=#FF0000>).{1,6}?(?=</font></a>.?</b>\\])"
#define POST_LIST_POST_AUTHOR_NAME_REGEX @"(?<=target=\"_blank\">).{1,15}(?=</a>)|(?<=<td width=80 nowrap class=tablebody2>).{1,15}?(?=</td>)"
#define POST_LIST_REPLY_NUM_REGEX @"(?<=<td width=\\* nowrap class=tablebody1>).*?(?=</td>)"
#define POST_LIST_LAST_REPLY_TIME_REGEX @"(?<=#bottom\">).*?(?=</a>)"
#define POST_LIST_LAST_REPLY_AUTHOR_REGEX @"(?<=usr\":\").*?(?=\")"
#define POST_LIST_POST_ENTITY_REGEX @"(?<=<tr style=\"vertical-align: middle;\">).*?(?=;</script>)"

#define USER_PROFILE_AVATAR_REGEX @"(?<=&nbsp;\\<img src=).*?(?= )"

#define HOT_TOPIC_WRAPPER @"&nbsp;<a href=\".*?(</td></tr><TR><TD align=middle|</td></tr><!--data)"
#define HOT_TOPIC_NAME_REGEX @"(?<=\\<font color=#000066>).*?(?=\\</font>)"
#define HOT_TOPIC_ID_REGEX @"(?<=&id=).*?(?=\" )"
#define HOT_TOPIC_BOARD_ID_REGEX @"(?<=boardid=)\\d{0,5}?(?=&id=)"
#define HOT_TOPIC_BOARD_NAME_WITH_AUTHOR_REGEX @"(?<=target=\"_blank\">).{0,30}?(?=</a></td><td height=20)"
#define HOT_TOPIC_POST_TIME_REGEX @"(?<=\">).{5,18}?(?=</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)"
#define HOT_TOPIC_CLICK_REGEX @"(?<=align=middle class=tablebody\\d>).*?(?=</td>)"