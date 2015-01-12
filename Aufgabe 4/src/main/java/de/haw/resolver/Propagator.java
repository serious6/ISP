package de.haw.resolver;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Propagator<T> implements Iterable<T> {

	protected String name;

	protected List<T> values = new ArrayList<T>();

	public Propagator(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void addValue(T value) {
		values.add(value);
	}

	public T getValue(int index) {
		return values.get(index);
	}

	public void empty() {
		values = new ArrayList<T>();
	}

	@Override
	public Iterator<T> iterator() {
		return values.iterator();
	}
}
