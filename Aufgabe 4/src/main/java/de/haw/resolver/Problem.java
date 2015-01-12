package de.haw.resolver;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Problem {

	private List<Constraint> constraints = new ArrayList<Constraint>();

	public List<Constraint> getConstraints() {
		final List<Constraint> result = new ArrayList<Constraint>();
		Collections.copy(result, constraints);
		return result;
	}

	public void addConstraint(final Constraint constraint) {
		if (constraint != null) {
			this.constraints.add(constraint);
		}
	}

	public void setConstraints(List<Constraint> constraints) {
		if (constraints != null) {
			this.constraints = constraints;
		}
	}

	public void solve() {
		if (constraints == null) {
			throw new IllegalArgumentException(
					"Es liegen keine Constraints vor...");
		}
		for (final Constraint constraint : constraints) {
			constraint.solve();
		}
	}

}
