package janusky;

import java.lang.management.ManagementFactory;
import java.util.Iterator;
import java.util.Set;

import javax.management.AttributeNotFoundException;
import javax.management.InstanceNotFoundException;
import javax.management.MBeanException;
import javax.management.MBeanRegistrationException;
import javax.management.MBeanServer;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;
import javax.management.ReflectionException;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebListener
public class MBeanContextListener implements ServletContextListener {

	private static final Logger LOG = LoggerFactory.getLogger(MBeanContextListener.class);

	@Override
	public void contextInitialized(final ServletContextEvent sce) {
		LOG.debug("Context Initialized..");
		try {
			final MBeanServer mbeanServer = ManagementFactory.getPlatformMBeanServer();
			// ObjectName query = new ObjectName("Catalina:*");
			ObjectName query = new ObjectName("Catalina:class=javax.sql.DataSource,*");
			Set<ObjectName> queryNames = mbeanServer.queryNames(query, null);
			for (Iterator<ObjectName> iter = queryNames.iterator(); iter.hasNext();) {
				ObjectName objName = iter.next();
				System.out.println(objName);
				if (objName.toString().contains("jdbc")) {
					Object value = mbeanServer.getAttribute(objName, "password");
					LOG.info("Data source password {}", value);
				}
//				unRegister(objName, mbeanServer);
			}
			LOG.debug("Initialized end");
		} catch (MalformedObjectNameException e) {
			e.printStackTrace();
		} catch (InstanceNotFoundException e) {
			e.printStackTrace();
		} catch (AttributeNotFoundException e) {
			e.printStackTrace();
		} catch (ReflectionException e) {
			e.printStackTrace();
		} catch (MBeanException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void contextDestroyed(final ServletContextEvent sce) {
		LOG.debug("Context Destroyed..");
	}

	void unRegister(ObjectName objName, MBeanServer mbeanServer) {
		try {
			mbeanServer.unregisterMBean(objName);
		} catch (MBeanRegistrationException | InstanceNotFoundException e) {
			LOG.error("Failed to unregister MBeans!", e);
		}
	}
}