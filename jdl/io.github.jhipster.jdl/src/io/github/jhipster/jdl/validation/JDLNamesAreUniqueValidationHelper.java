/**
 * Copyright 2016-2021 the original author or authors from the JHipster project.
 * 
 * This file is part of the JHipster project, see http://www.jhipster.tech/
 * for more information.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.github.jhipster.jdl.validation;

import java.util.Map;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.QualifiedName;
import org.eclipse.xtext.resource.IEObjectDescription;
import org.eclipse.xtext.validation.NamesAreUniqueValidationHelper;
import org.eclipse.xtext.validation.ValidationMessageAcceptor;

import io.github.jhipster.jdl.jdl.JdlAnnotation;
import io.github.jhipster.jdl.jdl.JdlDisplayField;
import io.github.jhipster.jdl.jdl.JdlRelationRole;

/**
 * @author Serano Colameo - Initial contribution and API
 */
public class JDLNamesAreUniqueValidationHelper extends NamesAreUniqueValidationHelper {

	@Override
	@SuppressWarnings("deprecation")
	protected void checkDescriptionForDuplicatedName(IEObjectDescription description,
			Map<EClass, Map<QualifiedName, IEObjectDescription>> clusterTypeToName,
			ValidationMessageAcceptor acceptor) {
		if (description == null)
			return;
		EObject element = description.getEObjectOrProxy();
		if (element instanceof JdlRelationRole || element instanceof JdlDisplayField
				|| element instanceof JdlAnnotation)
			return;
		super.checkDescriptionForDuplicatedName(description, clusterTypeToName, acceptor);
	}
}
