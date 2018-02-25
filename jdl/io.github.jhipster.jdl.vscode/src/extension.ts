'use strict';

import * as path from 'path';
import * as vscode from 'vscode';
import { PlantUMLRenderer } from './plantuml';
import { workspace, commands, Disposable, ExtensionContext, Uri } from 'vscode';
import { LanguageClient, LanguageClientOptions, ServerOptions } from 'vscode-languageclient';

let plantuml: PlantUMLRenderer;
var process = require('process');

export function activate(context: ExtensionContext) {
    // The server is a locally installed Java application
    let executable = process.platform == 'win32' ? 'xtext-server-jdl.bat' : 'xtext-server-jdl';
    let serverLauncher = context.asAbsolutePath(path.join('xtext-server-jdl', 'bin', executable));
    
    let serverOptions: ServerOptions = {
        run:   { command: serverLauncher }, 
        debug: { command: serverLauncher }
    }

    // Options to control the language client
    let clientOptions: LanguageClientOptions = {
        // Register the server for plain text documents
        documentSelector: ['jdl'],
        synchronize: {
            // Synchronize the setting section 'languageServerExample' to the server
            configurationSection: 'languageServerExample',
            // Notify the server about file changes to '.clientrc files contain in the workspace
            fileEvents: workspace.createFileSystemWatcher('**/*.*')
        }
    }
	
    process.env['XTEXT_SERVER_JDL_OPTS'] = "-Dpnguml.gen=true";

	// Create the language client and start the client.
    let langClient = new LanguageClient('JDL Xtext Server', serverOptions, clientOptions)
	let disposable = langClient.start();
    let activeEditor = vscode.window.activeTextEditor;
    //let result = commands.executeCommand("init", activeEditor.document.uri.toString())
	// Push the disposable to the context's subscriptions so that the 
	// client can be deactivated on extension deactivation
	context.subscriptions.push(disposable);
    plantuml = new PlantUMLRenderer(context);
    plantuml.init(langClient);
}

export function deactivate() {
    plantuml = null;
}
