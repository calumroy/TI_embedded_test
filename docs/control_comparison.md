
A comparison of the trades offs between sleectign different hardware and software to provide the overall control for a battery BMS systme and higher level control systems.

What are we trying to acheive?

We require a controller that we can setup to control a Subpack battery BMS as well as a controller controlling a group of subpacks together with possibly a cooling system to form an overall battery system for large vehicles in mining and other heavy industry.


## String controller

The strign manager design has considered using off the shelf automotive grade ECU's but has determined this to be unsatifactory 
See design consideration here:
https://www.notion.so/switchtechnologies/String-Manager-Design-Exploration-18fab03fd1e1809d84f2ebc1055afb6b
Main reasons:
  * Are we must design a board to interface with our chosen module BMS Texas Instruments chip anyway. 
  * Space considerations.
  * We want to reuse C code we developed already for the landcruiser

## Master BMS COntroller
We need a system wide controlelr that may control multiple subpacks / cooling equipment.
Responsble for manmaging the Subpacks and acting as a single interface for the battery system. 

## Drivetrain system controller

This needs to control adn interface to other system components.
We want a controller manageing electric drive line for some of our projects.
This requires mamnageing torque and powe rrequests and interface with vehciles systems like the CAT 785 truck.
This controller should be highly reliable and certifcation of this system shoiudl be considered as it will control power torque of electric drive train.
Resposnigle for turnign ont he electric system and takign driver comamndns (brake, accelerator pedal) and convertign to troque commands.
Must respond to faults and saftewy systems. 


# Considerations

- For any safety certified system the safety critical software and hardware should be simplified and minimized as much as possible
- What is the minimal list of requirements for the safety system.
- Do we really need an RTOS solution for a BMS or is a much simpler bare metal microcontroller good enough?
- Can we move any more complicated non safety critical funcitonality to a sperate system?
- Can we make debugging and software tooling as easy as possible to minimize the amount of times we need to use a JTAG debugger on the actual hardware to diagnose and fix bugs?

# Alternative Design

- Design a simple microcontroller board using bare metal board (not RTOS) that also contains the required BQ chipset. Make this as simple as possible and contain the safety critical application.
- Use an axiomatic or other commercial off the shelf relay driver and input/output board to actually switch the relays on/off.
- Move any complex functions that are not safety critical to an odroid or other non critical hardware to make development faster and easier.




## Software Considerations

Matlab Simulink
Good toolboxes to helpo simulate and integrate with hardware. Extensiverly used in automitvie. 
Can be very helpful in getting software verified.
Downsides is the sofware is expensive. There are many software licenses to pay not just to mathworks but also to the hardware manufacture for there toolboxes and support.
On going support fees form both mathworks and the hardware manufactures.
Software can be ported but only the code that does nto uise the hardwares toolboaes.
The hardware manufacture can be a blocker whne support is needed or bugs exist in their code. Hard an dexpensive to fix issues if it is in the propriatary toolbox code base.

We would like to implement CANopen on the subpacks and master BMS controllers. This is not supported on matlab simulink very well.
Debugging these systems remotelyis very difficulat with matlab simulink.
We can;t get direct access to low level feautres so impleemtning thisng like particular ehternet protocols we may need to interface with CAT trucks or train may be diffcult and not possible.



Codesys
More of a PLC type environment. Used extensively in Dirll rigs and other heavy industrie.
Codesys is cheap but again additional softeware lienecse to use particualrt hardware cna be expensive. 

Embedded CPU manufactures
These all provide there own software tools to program, compile and debug the embeeded chips.
Users are expected to design there own board based using the selected chips and then program them using the manufactures recommend toolchain.
  
Texas Insturments 
Code Composer
Debugging is done in codecomposer. 
Allwos programmign iusingf many diferenct compilers some opensource and some closed. Supports tools to certify software against industry standards. ect. 

STM32
CubeIDE. NMot good IDE bnased on eclipse. Poor documentation anbd project layout. 
Debugging in cubeIDE composer

NXP
MCUXpresso IDE>
(Fill out good and bad points about NXP)


Other stadnalone debuggers
Lauterbach with trace32. Expensive but good. Steep learing curve. Difficutlt to use and hard to learn if only occasionally debugging
A more preferable soiution is to use the saem IDE as what the program was programmed in. Trace32 does nto give us that option. 

Some Chip Hardware manaufactures provide more support and better documentation then others. Some are less prone to lock users into partiucular buidl chains and software tools

## Software Do's Don;ts

What I’m looking for in a chip SDK

My ideal chip SDK provides a way to build and flash projects using tools of my choosing. This seems like a low bar, but few meet it. Here are things chip SDKs should not do.
Don’t choose my laptop OS for me!

I left Windows behind when I worked at Sun Microsystems, and I have not looked back. Today, my daily driver is a MacBook Air. Unfortunately, some chip vendors require that you use their Windows-based tools to set up and build your projects. Now that most compilers are cross-platform, there is no excuse for it.
Don’t choose my IDE for me!

I’ve been using vim since college, and you can take it from my cold, dead hands. I love vim! I have it configured just so. It’s lightweight, it’s fast, and modal editing is the way to work (prove me wrong!). So you’ll understand my dismay at the spate of Eclipse-based IDEs chip vendors want to foist upon me. I want nothing to do with their boated, Java environments.

Instead of Eclipse-based IDE, I suggest SDKs provide Makefiles. make is the lowest common denominator build system, and is well supported by many tools. Bonus points for project files for IAR and Keil, since many of you like those tools.
Do include some examples

If a picture is worth a thousand words, then a working code example is worth a million. Give me one example of each of the main use cases for your MCU. Bonus points if you give me an example for each peripheral.


## Off the Shelf ECU condsiderations.

### Hydac TTC controllers
Old TTC 500 line of controllers
Can be programmed via Codesys, C/C++ API or Simulink Matlab.
THe C++ library provide good software supoport but agian these are propriatary libs. Care shoudl be taken to isolate the use of the library funciotns as much as possible

Down sides
TTC580 cannot be programmed via standard CAN or etherent prototcols and use pripriatary Hydac protioocl. This makes this line particualtrly frustinrating to update and use
The TTC580 requires programmign via an old ARM compiler using a particular build chain. This is not open source and relies on very outdated compolesr and priprioarty binary files.
Hydac are no longer maintinag this line bnut the tools do work
Debugging via Lauterbach trace32 softeware.
You must pusrchase an ECU that can be opened to debugg this sytem.
No support fo rCAN open on this hardware.


New controllers

### YDAC Industrial Controller TTC 2000 Series Software Review:

- Hydac TTC 2000 series ECU’s provides no support for implementing CAN open.
If we wanted to implement our BMS as a CANopen node to follow what other Subpack Suppliers (e.g ABB) do then trying to use an Open source C CANopen library like https://github.com/CANopenNode/CANopenNode?tab=readme-ov-file may be more difficult (but not impossible) then other controllers that offer more freedom with the software programming tools.
- The HYDAC TTC 2000 series ECU’s software runs in periodic loops usually as tasks that are configured to a particular threads. This is different to the the previous TTC500 series controllers which did not offer any threading.
- Debugging for HYDAC ECU is expensive and difficult compared to other embedded platforms or full linux OS embedded board. HYDAC uses TRACE32 software from Lauterbach. These require expensive software licenses and very specific hardware dongles (a different dongle for every CPU type is required) and requires connecting to debug versions of the HYDAC ECU (debug versions can be opened up so the Lauterbach USB dongles can connect to a terminal inside the ECU case). If you don’t have a debug version then you can’t debug with TRACE32.
    - TRACE32 is complicated and not easy to use. I spent significant amounts of time trying to debug stack overflow errors on the ECU (something that TRACE32 should have made very apparent when the ECU was running out of stack memory).
- The HYDAC TTC2000 series uses a new underlying proprietary OS (different OS then the TTC500’s series ECU) called **PXROS-HR OS (Portable eXtendible Real-time Operating System—High Reliability)**. This makes separating code specific to the HYDAC ECU from the rest of the logic harder as any call to the HYDAC specific libraries or functions has to be isolated in a way from the rest of the user code base. If we don’t do this correctly we end up with a system that cannot be unit tested or integrated against a CI/CD (continuous integration and development testing via github actions) system and cannot be ported to other platforms. The purpose of HYDAC and  PXROS-HR OS in doing this is to lock user into their platform so it is hard to move platforms without doing a large rewrite of the code base.
    - The PXROS-HR OS uses driver libraries similar to the TTC500 series but also also includes new specific concepts unique to the PXROS-HR OS such as:
        - message envelopes: For passing data between application SW tasks and I/O Driver tasks.
        - UCM – User space communication: This is a mechanism implemented by TTControl where the application SW must provide the data buffer. The buffer is managed internally by the I/O Driver
        - UCM – User-space communication mechanism: The UCM is an I/O Driver layer that handles data exchange between user tasks and I/O Driver tasks using an asynchronous inter-process communication. It has been implemented by TTControl as an alternative to PXROS-HR messages with better performance.
        - PXROS-HR specific thread communication: PXROS-HR implements its own library for sending data between tasks (threads). This can help with implementing multitasking but comes with the downsides of not being portable and preventing testing outside the HYDAC ECU.


Other off the shelf ECU hardfware

OpenECU from Piinnovo.

Motec ect.

br-automation
Uses automoitve grade ECU's. Part of ABB ghroup they push their Automation Studio but it is hard to find details on this.
list some others

Most of these provide somwe matlab simulaink blockl sets. A user then buy licenses fomr the manbufacture to use these and some prioprtatry compiler and the Mathworks libncenseas then program sin thewse enviropmenets,.
Code inevitably gets tied to these software enviropnemnts

### Full linux hardened PC
Many manuifactures proivede embedded hardeend linux PC for Automitve use,.
These come within many peripherals. 
Gives the mmost flexibility for software developketn dand debugging.
Maybe harder to get this certiced in the future espeicailly if it is part of a safety criutical system like the Estop or motor torque control.

## Preferneces

We don;t want to buy, learn and code in m,utliple soft3eare enviroments,.
Keeping a single softweare development, build chain and debugging tools makes it easier to support multiple projects.
It would be nice to not be locked into a particular software envrioment yet as we are unsure of the future needs on our current proejects.
We would like the options to move softweare builds to other toolchains int he furutere

We would prefer not to be locked tio an particualr IDE or softwarer for debugging.
We want to be able to supprot over the air (CAN or ewhterrnet ) updates using common protocols.
We would like support to use some simulink mathworks tools at least for simulating parts of the system.

