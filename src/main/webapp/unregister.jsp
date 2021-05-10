<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, javax.management.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>MBean unregister</title>
</head>
<body>
	<p><a href="/">Home</a>&nbsp;<a href="jmx.jsp">List</a>&nbsp;<a href="unregister.jsp" target="_self">Reload</a></p>
<%
    ArrayList list = MBeanServerFactory.findMBeanServer(null);
    MBeanServer mbeanServer = (MBeanServer) list.get(0);

    StringBuilder outUnregister = new StringBuilder("");
    StringBuilder outList = new StringBuilder("");
	outList.append("<strong>MBeanServer</strong>: " + mbeanServer + "<br>");
    String domain = mbeanServer.getDefaultDomain();
    outList.append("<strong>Default domain</strong>: " + domain + "<br>");

    Set queryNames = mbeanServer.queryNames(null, null);
	for (Iterator iter = queryNames.iterator(); iter.hasNext();) {
		ObjectName objName = (ObjectName) iter.next();
		System.out.println(objName);
		if (objName.toString().contains("test_web")) {
			try {
				Object value = mbeanServer.getAttribute(objName, "password");
				outUnregister.append("<p><strong style='color:green;'>" + objName + "</strong> (Pass=" + value + ")</p>");
			} catch (Exception e) {
				out.print("<p><strong style='color:rgb(110, 28, 35);'>" + objName + "</strong> (Pass=Not access)</p>");
			}
			try {
				mbeanServer.unregisterMBean(objName);
				outUnregister.append("<p><strong style='color:blueviolet;'>" + objName + "</strong> unregisterMBean OK</p>");
			} catch (Exception e) {
				outUnregister.append("<p><strong style='color:rgb(110, 28, 35);'>" + objName + "</strong> unregisterMBean FAIL!</p>");
			}
		} else {
        	outList.append(objName + "<br>");
		}
	}

	if (outUnregister.length() > 0) {
		out.print(outUnregister);
	} else {
		out.print("<p><strong style='color:blueviolet;'> Not found MBeans for UnRegister!</strong></p>");
	}
	out.print("<hr/>");
	out.print(outList);
%>
</body>
</html>