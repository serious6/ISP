package de.haw.resolver;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

public class Problem implements Iterable<Constraint> {

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

	public void solve() {
		if (constraints == null) {
			throw new IllegalArgumentException(
					"Es liegen keine Constraints vor...");
		}
		final Queue<Constraint> alle = new LinkedList<Constraint>(constraints);
		while (!alle.isEmpty()) {
			final Constraint current = alle.remove();
			if (entferneInkonsistenteWerte(current.left, current.right)) {
				// nachbar
				alle.add(new Constraint(null, current.left));
			}
		}
	}

	private boolean entferneInkonsistenteWerte(Propagator<?> left,
			Propagator<?> right) {
		boolean removed = false;

		return removed;
	}

	@Override
	public Iterator<Constraint> iterator() {
		return constraints.iterator();
	}

}
