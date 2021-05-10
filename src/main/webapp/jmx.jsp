<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, javax.management.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>List JXM MBean</title>
</head>
<body>
	<p><a href="/">Home</a>&nbsp;<a href="unregister.jsp">Unregister</a></p>
<%
    ArrayList list = MBeanServerFactory.findMBeanServer(null);
    MBeanServer mbeanServer = (MBeanServer) list.get(0);

    out.print("<strong>MBeanServer</strong>: " + mbeanServer + "<br>");
    String domain = mbeanServer.getDefaultDomain();
    out.print("<strong>Default domain</strong>: " + domain + "<br>");

    Set<ObjectName> queryNames = mbeanServer.queryNames(null, null);
	for (Iterator iter = queryNames.iterator(); iter.hasNext();) {
		ObjectName objName = (ObjectName) iter.next();
		System.out.println(objName);
		if (objName.toString().contains("test_web")) {
			try {
				Object value = mbeanServer.getAttribute(objName, "password");
				out.print("<p><strong style='color:green;'>" + objName + "</strong> (Pass=" + value + ")</p>");
			} catch (Exception e) {
				out.print("<p><strong style='color:rgb(110, 28, 35);'>" + objName + "</strong> (Pass=FAIL!)</p>");
			}
		} else {
        	out.print(objName + "<br>");
		}
	}
%>
</body>
</html>