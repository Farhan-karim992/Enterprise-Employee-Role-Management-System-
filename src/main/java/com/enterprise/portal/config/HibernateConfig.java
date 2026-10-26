package com.enterprise.portal.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.orm.hibernate5.HibernateTransactionManager;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.util.Properties;

/**
 * Enterprise Hibernate & DataSource Configuration.
 * Demonstrates SessionFactory bean lifecycle, transaction management boundaries,
 * and HikariCP connection pooling.
 */
@Configuration
@EnableTransactionManagement
@PropertySource("classpath:database.properties")
public class HibernateConfig {

    @Autowired
    private Environment env;

    @Bean
    public DataSource dataSource() {
        HikariConfig config = new HikariConfig();
        config.setDriverClassName(env.getRequiredProperty("jdbc.driverClassName"));
        config.setJdbcUrl(env.getRequiredProperty("jdbc.url"));
        config.setUsername(env.getRequiredProperty("jdbc.username"));
        config.setPassword(env.getRequiredProperty("jdbc.password"));
        
        config.setMaximumPoolSize(Integer.parseInt(env.getProperty("hikaricp.maximumPoolSize", "20")));
        config.setMinimumIdle(Integer.parseInt(env.getProperty("hikaricp.minimumIdle", "5")));
        config.setIdleTimeout(Long.parseLong(env.getProperty("hikaricp.idleTimeout", "30000")));
        config.setConnectionTimeout(Long.parseLong(env.getProperty("hikaricp.connectionTimeout", "20000")));
        config.setMaxLifetime(Long.parseLong(env.getProperty("hikaricp.maxLifetime", "1800000")));
        
        return new HikariDataSource(config);
    }

    @Bean
    public LocalSessionFactoryBean sessionFactory() {
        LocalSessionFactoryBean sessionFactory = new LocalSessionFactoryBean();
        sessionFactory.setDataSource(dataSource());
        sessionFactory.setPackagesToScan("com.enterprise.portal.entity");
        sessionFactory.setHibernateProperties(hibernateProperties());
        return sessionFactory;
    }

    private Properties hibernateProperties() {
        Properties properties = new Properties();
        properties.put("hibernate.dialect", env.getRequiredProperty("hibernate.dialect"));
        properties.put("hibernate.show_sql", env.getProperty("hibernate.show_sql", "true"));
        properties.put("hibernate.format_sql", env.getProperty("hibernate.format_sql", "true"));
        properties.put("hibernate.hbm2ddl.auto", env.getProperty("hibernate.hbm2ddl.auto", "validate"));
        properties.put("hibernate.current_session_context_class", 
                env.getProperty("hibernate.current_session_context_class", "org.springframework.orm.hibernate5.SpringSessionContext"));
        return properties;
    }

    @Bean
    public PlatformTransactionManager hibernateTransactionManager() {
        HibernateTransactionManager transactionManager = new HibernateTransactionManager();
        transactionManager.setSessionFactory(sessionFactory().getObject());
        return transactionManager;
    }
}
