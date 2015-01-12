package de.haw.resolver;

public abstract class Constraint {

	protected Propagator left;
	protected Propagator right;

	protected Propagator result;

	public Propagator getLeft() {
		return left;
	}

	public void setLeft(Propagator left) {
		this.left = left;
	}

	public Propagator getRight() {
		return right;
	}

	public void setRight(Propagator right) {
		this.right = right;
	}

	public abstract void solve();

}
