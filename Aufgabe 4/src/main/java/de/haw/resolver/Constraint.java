package de.haw.resolver;

import java.util.ArrayList;
import java.util.List;

public abstract class Constraint {

	protected Constraint left;
	protected Constraint right;

	protected List<?> values = new ArrayList<>();

	public Constraint getLeft() {
		return left;
	}

	public void setLeft(Constraint left) {
		this.left = left;
	}

	public Constraint getRight() {
		return right;
	}

	public void setRight(Constraint right) {
		this.right = right;
	}

	public List<?> getValues() {
		return values;
	}

}
