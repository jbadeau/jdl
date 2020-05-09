/*******************************************************************************
 * Copyright (c) 2015 itemis Schweiz GmbH (http://www.itemis-schweiz.ch) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package ch.itemis.xdocker.base.processor

import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.RegisterGlobalsContext
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.ClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility

/**
 * Extracts an interface for all locally declared public methods.
 * 
 * @author Serano Colameo - Initial contribution and API
 */

@Target(ElementType.TYPE)
@Active(ExtractInterfaceProcessor)
annotation ExtractInterfaceActiveAnnotation {}

/**
 * Extracts an Interface from a Class
 */
class ExtractInterfaceProcessor extends AbstractClassProcessor {
	
	override doRegisterGlobals(ClassDeclaration annotatedClass, RegisterGlobalsContext context) {
		context.registerInterface(annotatedClass.interfaceName)
	}

	def getInterfaceName(ClassDeclaration annotatedClass) {
		val ifaceName = 'I' + annotatedClass.simpleName
		annotatedClass.qualifiedName.replaceAll(annotatedClass.simpleName, ifaceName)
	}
	
	override doTransform(MutableClassDeclaration annotatedClass, extension TransformationContext context) {
		val interfaceType = findInterface(annotatedClass.interfaceName)
		interfaceType.primarySourceElement = annotatedClass
		// add the interface to the list of implemented interfaces
		annotatedClass.implementedInterfaces = annotatedClass.implementedInterfaces + #[interfaceType.newTypeReference]
		// add the public methods to the interface
		for (method : annotatedClass.declaredMethods) {
			if (method.visibility == Visibility.PUBLIC) {
				interfaceType.addMethod(method.simpleName) [
					docComment = method.docComment
					returnType = method.returnType
					for (p : method.parameters) {
						addParameter(p.simpleName, p.type)
					}
					exceptions = method.exceptions
					primarySourceElement = method
				]
			}
		}
	}	
}
