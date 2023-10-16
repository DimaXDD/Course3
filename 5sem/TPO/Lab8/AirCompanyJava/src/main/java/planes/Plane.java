package planes;

import java.util.Objects;

abstract public class Plane {
    private final int maxSpeed;
    private final int maxFlightDistance;
    private final int maxLoadCapacity;
    private final String model;

    public Plane(String model, int maxSpeed, int maxFlightDistance, int maxLoadCapacity) {
        this.model = model;
        this.maxSpeed = maxSpeed;
        this.maxFlightDistance = maxFlightDistance;
        this.maxLoadCapacity = maxLoadCapacity;
    }

    public String getModel() {
        return model;
    }

    public int getMaxSpeed() {
        return maxSpeed;
    }

    public int getMaxFlightDistance() {
        return maxFlightDistance;
    }

    public int getMinLoadCapacity() {
        return maxLoadCapacity;
    }

    @Override
    public String toString() {
        return "\n\tPlane{" +
                "model='" + model + '\'' +
                ", maxSpeed=" + maxSpeed +
                ", maxFlightDistance=" + maxFlightDistance +
                ", maxLoadCapacity=" + maxLoadCapacity +
                '}';
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj instanceof Plane) {
            Plane plane = (Plane) obj;
            return maxSpeed == plane.maxSpeed &&
                    maxFlightDistance == plane.maxFlightDistance &&
                    maxLoadCapacity == plane.maxLoadCapacity &&
                    Objects.equals(model, plane.model);
        }
        return false;
    }

    @Override
    public int hashCode() {
        return Objects.hash(model, maxSpeed, maxFlightDistance, maxLoadCapacity);
    }
}