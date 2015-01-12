package de.haw.resolver;

public class Constraint {

	protected Propagator<?> left;
	protected Propagator<?> right;

	protected Propagator<?> result;

	public Constraint(Propagator<?> left, Propagator<?> right) {
		super();
		this.left = left;
		this.right = right;
	}

	public Propagator<?> getLeft() {
		return left;
	}

	public Propagator<?> getRight() {
		return right;
	}

	public void setLeft(Propagator<?> left) {
		this.left = left;
	}

	public void setRight(Propagator<?> right) {
		this.right = right;
	}

	public Propagator<?> getResult() {
		return result;
	}

	public void solve() {

	}

	public Constraint flip() {
		return new Constraint(right, left);
	}

}
