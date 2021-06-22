public class ParkLocator {
	public static String[] country(string arg) {
        ParkService.ParksImplPort country = new ParkService.ParksImplPort();
        return country.byCountry(arg);
    }
}