package io.github.jhipster.jdl.ui.wizard;

import org.eclipse.osgi.util.NLS;

public class Messages extends NLS {
	private static final String BUNDLE_NAME = "io.github.jhipster.jdl.ui.wizard.messages"; //$NON-NLS-1$
	
	public static String MonolithProject_Label;
	public static String MonolithProject_Description;
	public static String JHipsterProject_Label;
	public static String JHipsterProject_Description;
	public static String JHipsterMonolithProject_Label;
	public static String JHipsterMonolithProject_Description;
	public static String JHipsterProjectFromCli_Label;
	public static String JHipsterProjectFromCli_Description;
	public static String JHipsterMonolithProject2_Label;
	public static String JHipsterMonolithProject2_Description;
	public static String JHipsterMicroserviceProject_Label;
	public static String JHipsterMicroserviceProject_Description;
	public static String JHipsterGatewayProject_Label;
	public static String JHipsterGatewayProject_Description;
	
	static {
	// initialize resource bundle
	NLS.initializeMessages(BUNDLE_NAME, Messages.class);
	}

	private Messages() {
	}
}
