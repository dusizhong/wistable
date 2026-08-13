package com.apitable.shared.exception;

import com.apitable.core.exception.BaseException;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * limit exception.
 *
 * @author Shawn Deng
 */
@Getter
@AllArgsConstructor
public enum LimitException implements BaseException {

    FORBIDDEN_ACCESS(1500, "forbidden access"),

    OVER_LIMIT(1501, "exceed over limit"),

    WIDGET_OVER_LIMIT(1502, "超出空间最大小组件数限制"),

    SEATS_OVER_LIMIT(1503, "超出空间最大成员数限制"),

    CHAT_BOT_OVER_LIMIT(1503, "超出空间最大聊天机器人数量限制"),

    CREDIT_OVER_LIMIT(1504, "超出 AI 积分限制"),

    FILE_NUMS_OVER_LIMIT(1505, "超出空间最大文件数限制");

    private final Integer code;

    private final String message;
}
