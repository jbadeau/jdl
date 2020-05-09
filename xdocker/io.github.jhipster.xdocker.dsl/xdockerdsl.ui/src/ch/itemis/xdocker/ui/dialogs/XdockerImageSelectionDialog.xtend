/** 
 * Copyright (c) 2015 itemis Schweiz GmbH (http://www.itemis-schweiz.ch) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package ch.itemis.xdocker.ui.dialogs

import java.util.Stack
import java.util.concurrent.ExecutorService
import java.util.concurrent.TimeUnit
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Status
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Shell

import static ch.itemis.xdocker.ui.util.MessageUtil.*

/** 
 * Xdocker Image Selection Dialog
 * 
 * @author Serano Colameo - Initial contribution and API
 */
class XdockerImageSelectionDialog extends AbstractXdockerSelectionDialog {

	new(Shell shell, String title, String message) {
		super(shell, title, message)
	}

	override runnable(ExecutorService executorService) {
		val status = new Stack<IStatus> 
		return [ IProgressMonitor pm |
			try {
				pm.beginTask("Load docker image list", 15)
				executorService.execute([
					try {
						docker [
							images => [
								if (!nullOrEmpty) {
									forEach[content.addAll(repoTags)]
								}
							]
						]
						status.push(Status.OK_STATUS)
					} catch (Exception e) {
						status.push(Status.OK_STATUS)
						executorService.shutdownNow
						Display.^default.asyncExec([
							error("Error contacting Docker...", '''Could not get image list from Docker! «e.getMessage()»''')
						])
					}
				])
				var unit = 1
				var finshed = false
				for (var i = 0; i < 15 && !finshed; i += unit) {
					try {
						finshed = !status.isEmpty() && status.peek().isOK()
						pm.worked(unit)
						pm.subTask('''...executing Docker command, please wait («(i + unit)»s)''')
						if (executorService.isShutdown() || executorService.isTerminated()) {
							finshed = true
						}
						executorService.awaitTermination(unit, TimeUnit.SECONDS)
					} catch (InterruptedException e) {
						finshed = true
					}
				}
			} finally {
				executorService.shutdownNow
				docker.close
				pm.done
			}
		]	
	} 
}