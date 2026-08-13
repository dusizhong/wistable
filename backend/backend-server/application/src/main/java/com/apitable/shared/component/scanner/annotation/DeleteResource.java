/**
 * HTTP DELETE 请求资源注解，配合 ApiResourceScanner 实现 DELETE 接口的自动权限扫描注册。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

package com.apitable.shared.component.scanner.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import org.springframework.core.annotation.AliasFor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@RequestMapping(method = RequestMethod.DELETE)
public @interface DeleteResource {

    @AliasFor(annotation = RequestMapping.class)
    String name() default "";

    @AliasFor(annotation = RequestMapping.class)
    String[] value() default {};

    @AliasFor(annotation = RequestMapping.class)
    String[] path() default {};

    @AliasFor(annotation = RequestMapping.class)
    String[] params() default {};

    @AliasFor(annotation = RequestMapping.class)
    String[] headers() default {};

    @AliasFor(annotation = RequestMapping.class)
    String[] consumes() default {};

    @AliasFor(annotation = RequestMapping.class)
    String[] produces() default {};

    String code() default "";

    String description() default "";

    @AliasFor(annotation = RequestMapping.class)
    RequestMethod[] method() default RequestMethod.DELETE;

    boolean requiredLogin() default true;

    boolean requiredPermission() default true;

    String[] tags() default {};

    boolean requiredAccessDomain() default false;

    boolean ignore() default false;
}
