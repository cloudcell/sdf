/**
 * Return the number of total number of cores(processors) Java sees on the target system.
 * Credit: https://wiki.windward.net/Wiki/09.Knowledge_Base/Finding_out_the_number_of__cores_%28processors%29_your_system_has
 */
public class NumberOfCores {

	public static void main(String[] args) {

		System.out.println("Total number of system cores(processors): " + Runtime.getRuntime().availableProcessors());
	}
}
