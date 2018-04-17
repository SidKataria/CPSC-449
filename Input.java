import java.io.*;

public class Input {
	public String name;
	
	// forcedPartialAssignment[i] = j: task j must be assigned to machine i
	// Default: null
	public Task[] forcedPartialAssignment = new Task[8];
	
	// forbiddenMachine[i] = j: assigning task j to machine i is invalid
	// Default: null
	public Task[][] forbiddenMachine = new Task[8][8];
	
	// if tooNearTasks[i][j] = -1: task i and task j are too-near
	// if tooNearTasks[i][j] = 0: no penalty
	// otherwise: too-near penalty (actual value)
	public int[][] tooNearTasksAndPenalties = new int[8][8];
	
	// penalties (actual values)
	public int[][] machinePenalties = new int[8][8];
	
	public boolean nameFound, fpaFound, fmFound, tntFound, mpFound, tnpFound; // 6 keys to find
	
	public boolean parseFile(String filename) throws Exception {
		FileReader fr = null;
		BufferedReader br = null; 
		try {
			fr = new FileReader(filename);
			br = new BufferedReader(fr); 
			String line;
			
			while((line = br.readLine()) != null) {
				String trimmedLine = line.trim();
				if (trimmedLine.isEmpty()) { // if line was blank...
					continue;
				}
				String keyName = trimmedLine.toLowerCase();
				switch (keyName) {
					case "name:":
					case "name":
						nameFound = true; // *** Should we move these boolean assignments inside the below functions? ***
						// name helper function call
						break;
					case "forced partial assignment:":
					case "forced partial assignment":
						fpaFound = true;
						// fpa helper function call
						break;
					case "forbidden machine:":
					case "forbidden machine":
						fmFound = true;
						// fm helper function call
						break;
					case "too-near tasks:":
					case "too-near tasks":
						tntFound = true;
						// tnt helper function call
						break;
					case "machine penalties:":
					case "machine penalties":
						mpFound = true;
						// mp helper function call
						break;
					case "too-near penalties:":
					case "too-near penalties":
						tnpFound = true;
						// tnp helper function call
						break;
					default:
						System.out.println("Error while parsing input file (key missing or unrecognized/mispelled key)");
				}
				
			}
			
		}catch (FileNotFoundException e) {
			System.out.println("Error: The specified file was not found.");
			// quit
		}finally {
			if (fr != null) {
				fr.close();
			}	
		}
		
		
		return nameFound && fpaFound && fmFound && tntFound && mpFound && tnpFound; // return if parsing was successful
	}
	
	// helpers will return if they were successful or not
	// eventually these boolean returns will dictate if execution continues or not (and what error message to print, if any)
	private boolean setName(BufferedReader br) throws Exception {
		// read next line + set name = line if not empty
		String line = br.readLine();
		if (line != null) {
			String trimmedLine = line.trim();
			if (trimmedLine.isEmpty()) {
				return false; // since no value was specified directly below the keyword "Name"
			}
			name = trimmedLine; // set value of "Name"
		}
	}
	
	private boolean setFPA(BufferedReader br) throws Exception {
		// read next line(s) until empty line found (make sure counter tracking number of read lines is in [0,8]
		// error check that no assignments overlap (2 pairs share a machine or a task)
		// set FPA array
		// NOTE: an error will occur when 2 pairs overlap, Case 1: <=8 pairs provided with an overlap or Case 2: >8 pairs (first 8 pairs were read without overlap, then the 9th pair has to overlap)
		// e.g. (1,A) ; (2,B) ; (3,C) ; (4,D) ; (5,E) ; (6,F) ; (7,G) ; (8,H) ; then (4,G) is found which throws an error since 4 is linked to D already.
		// *** Therefore before adding Tasks.valueOf(*task*) to forcedPartialAssignment array at index *mach*, we should make sure element is null. If !null, return false ***
		String line;
		while ((line = br.readLine()) != null) {
			String trimmedLine = line.trim();
			if (trimmedLine.isEmpty()) {
				return true;
			}
			String[] segments = trimmedLine.split("[(,)]"); // results in {" ",*mach*,*task*}
			int machine = Integer.parseInt(segments[1]); // *** need to handle exceptions
			Task task = Task.valueOf(segments[2]);
			if (forcedPartialAssignment[machine-1] == null) {
				forcedPartialAssignment[machine-1] = task // store task in array if slot is empty (meaning machine hasnt been assigned a task yet
			}
			else {
				return false; // error (overlapping machine occurred)
			}
			// NOTE: once returned, need to check that array contains no duplicate tasks (convert to a set and length should be same as array)
		}
	}
	
	private boolean setFM(BufferedReader br) {
		// similar to setFPA()
		return false;
	}
	
	private boolean setTNT(BufferedReader br) {
		// similar to setFPA()
		return false;
	}
	
	private boolean setMP(BufferedReader br) {
		// read next 8 lines (return false if line is empty or doesnt have exactly 8 entries (natural numbers))
		return false;
	}
	
	private boolean setTNP(BufferedReader br) {
		// similar to setFPA()
		return false;
	}
	
	
}
