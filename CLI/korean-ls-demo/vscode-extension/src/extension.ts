import * as vscode from 'vscode';
import { KoreanLanguageClient } from './client';
import { Configuration } from './configuration';

let client: KoreanLanguageClient | undefined;
let statusBarItem: vscode.StatusBarItem | undefined;
let outputChannel: vscode.OutputChannel | undefined;

/**
 * Extension activation function
 * Called when the extension is activated
 */
export async function activate(context: vscode.ExtensionContext): Promise<void> {
    console.log('Korean Language Server extension is now active');

    // Create output channel for logging
    outputChannel = vscode.window.createOutputChannel('Korean Language Server');
    context.subscriptions.push(outputChannel);

    // Create status bar item
    statusBarItem = vscode.window.createStatusBarItem(
        vscode.StatusBarAlignment.Right,
        100
    );
    statusBarItem.text = '$(loading~spin) Korean LS';
    statusBarItem.tooltip = 'Korean Language Server is starting...';
    context.subscriptions.push(statusBarItem);

    // Create and start the language client
    client = new KoreanLanguageClient(context, outputChannel);

    try {
        await client.start();
        updateStatusBar('running');
        outputChannel.appendLine('Extension activated successfully');
    } catch (error) {
        updateStatusBar('error');
        const errorMessage = error instanceof Error ? error.message : String(error);
        outputChannel.appendLine(`Failed to activate extension: ${errorMessage}`);
    }

    // Register commands
    registerCommands(context);

    // Register configuration change listener
    const configDisposable = Configuration.onConfigurationChanged(async (e) => {
        outputChannel?.appendLine('Configuration changed, restarting server...');
        
        if (Configuration.hasChanged(e, 'serverPath') || 
            Configuration.hasChanged(e, 'logLevel') ||
            Configuration.hasChanged(e, 'trace.server')) {
            try {
                await client?.restart();
                updateStatusBar('running');
                outputChannel?.appendLine('Server restarted successfully');
            } catch (error) {
                updateStatusBar('error');
                const errorMessage = error instanceof Error ? error.message : String(error);
                outputChannel?.appendLine(`Failed to restart server: ${errorMessage}`);
            }
        }
    });
    context.subscriptions.push(configDisposable);
}

/**
 * Extension deactivation function
 * Called when the extension is deactivated
 */
export async function deactivate(): Promise<void> {
    if (client) {
        await client.stop();
        client = undefined;
    }

    if (statusBarItem) {
        statusBarItem.dispose();
        statusBarItem = undefined;
    }

    if (outputChannel) {
        outputChannel.appendLine('Extension deactivated');
        outputChannel.dispose();
        outputChannel = undefined;
    }
}

/**
 * Register extension commands
 */
function registerCommands(context: vscode.ExtensionContext): void {
    // Command: Restart Language Server
    const restartCommand = vscode.commands.registerCommand(
        'koreanLanguageServer.restart',
        async () => {
            if (!client) {
                vscode.window.showWarningMessage('Language server is not running');
                return;
            }

            try {
                updateStatusBar('restarting');
                await client.restart();
                updateStatusBar('running');
                vscode.window.showInformationMessage('Korean Language Server restarted');
            } catch (error) {
                updateStatusBar('error');
                const errorMessage = error instanceof Error ? error.message : String(error);
                vscode.window.showErrorMessage(
                    `Failed to restart language server: ${errorMessage}`
                );
            }
        }
    );
    context.subscriptions.push(restartCommand);

    // Command: Show Output
    const showOutputCommand = vscode.commands.registerCommand(
        'koreanLanguageServer.showOutput',
        () => {
            outputChannel?.show();
        }
    );
    context.subscriptions.push(showOutputCommand);

    // Command: Stop Language Server
    const stopCommand = vscode.commands.registerCommand(
        'koreanLanguageServer.stop',
        async () => {
            if (!client) {
                vscode.window.showWarningMessage('Language server is not running');
                return;
            }

            try {
                await client.stop();
                updateStatusBar('stopped');
                vscode.window.showInformationMessage('Korean Language Server stopped');
            } catch (error) {
                const errorMessage = error instanceof Error ? error.message : String(error);
                vscode.window.showErrorMessage(
                    `Failed to stop language server: ${errorMessage}`
                );
            }
        }
    );
    context.subscriptions.push(stopCommand);

    // Command: Start Language Server
    const startCommand = vscode.commands.registerCommand(
        'koreanLanguageServer.start',
        async () => {
            if (client?.isRunning()) {
                vscode.window.showWarningMessage('Language server is already running');
                return;
            }

            try {
                updateStatusBar('starting');
                await client?.start();
                updateStatusBar('running');
                vscode.window.showInformationMessage('Korean Language Server started');
            } catch (error) {
                updateStatusBar('error');
                const errorMessage = error instanceof Error ? error.message : String(error);
                vscode.window.showErrorMessage(
                    `Failed to start language server: ${errorMessage}`
                );
            }
        }
    );
    context.subscriptions.push(startCommand);
}

/**
 * Update status bar item based on server state
 */
function updateStatusBar(state: 'starting' | 'running' | 'stopped' | 'error' | 'restarting'): void {
    if (!statusBarItem) {
        return;
    }

    switch (state) {
        case 'starting':
            statusBarItem.text = '$(loading~spin) Korean LS';
            statusBarItem.tooltip = 'Korean Language Server is starting...';
            statusBarItem.backgroundColor = undefined;
            statusBarItem.show();
            break;
        case 'running':
            statusBarItem.text = '$(check) Korean LS';
            statusBarItem.tooltip = 'Korean Language Server is running';
            statusBarItem.backgroundColor = undefined;
            statusBarItem.show();
            break;
        case 'stopped':
            statusBarItem.text = '$(circle-slash) Korean LS';
            statusBarItem.tooltip = 'Korean Language Server is stopped';
            statusBarItem.backgroundColor = undefined;
            statusBarItem.show();
            break;
        case 'error':
            statusBarItem.text = '$(error) Korean LS';
            statusBarItem.tooltip = 'Korean Language Server encountered an error';
            statusBarItem.backgroundColor = new vscode.ThemeColor('statusBarItem.errorBackground');
            statusBarItem.show();
            break;
        case 'restarting':
            statusBarItem.text = '$(sync~spin) Korean LS';
            statusBarItem.tooltip = 'Korean Language Server is restarting...';
            statusBarItem.backgroundColor = undefined;
            statusBarItem.show();
            break;
    }
}
