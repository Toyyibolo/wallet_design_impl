import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() => runApp(const WalletDesign());

class WalletDesign extends StatefulWidget {
  const WalletDesign({super.key});

  @override
  State<WalletDesign> createState() => _WalletDesignState();
}

class _WalletDesignState extends State<WalletDesign> {
  StateMachineController? controller;
  SMITrigger? isOpenInput;
  SMITrigger? isClosedInput;
  bool isOpen = false;

  TextValueRun? firstCardText;
  TextValueRun? secondCardText;
  TextValueRun? thirdCardText;

  void _onRiveInit(Artboard artboard) {
    controller = StateMachineController.fromArtboard(artboard,'walletStateMachine');
    if (controller != null) {
      artboard.addController(controller!);
      isOpenInput = controller!.findSMI('o') as SMITrigger;
      isOpenInput != null ? debugPrint('openIt found') : debugPrint('openIt not found');
      isClosedInput = controller!.findSMI('c') as SMITrigger;
      isClosedInput != null ? debugPrint('closeIt found') : debugPrint('closeIt not found');


      firstCardText = artboard.component<TextValueRun>('balancePounds')!;
      secondCardText = artboard.component<TextValueRun>('balanceEuro')!;
      thirdCardText = artboard.component<TextValueRun>('balanceDollar')!;

      
    } else {
      debugPrint('Error: Could not find the State Machine "wallet".');
    }
  }

  void toggleWallet() {
    if (isOpenInput != null && isClosedInput != null) {
      if (isOpen) {
        isClosedInput?.fire();
      } else {
        isOpenInput?.fire();
      }
      setState(() {
        isOpen = !isOpen;
        updateText();
      });
    } else {
      debugPrint('Error: Inputs are not initialized.');
    }
  }

  updateText() {
    if (firstCardText != null && secondCardText != null && thirdCardText != null) {
      firstCardText?.text = isOpen ? '£10000' : '********';
      secondCardText?.text = isOpen ? '€26000' : '********';
      thirdCardText?.text = isOpen ? '\$65000' : '********';
    } else {
      debugPrint('Error: Text components are not initialized.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wallet Design'),
        ),
        body: Center(
          child: SizedBox(
            width: 400,
            height: 300,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: SizedBox(
                    width: 400,
                    height: 300,
                    child: RiveAnimation.asset(
                      'assets/rive/wallety.riv',
                      artboard: 'walletboard',
                      fit: BoxFit.cover,
                      onInit: _onRiveInit,
                    ),
                  ),
                ),
                Positioned(
                  left: 170,
                  bottom: 130,
                  child: Text(
                    isOpen ? '\$100000' : '********',
                    style: TextStyle(
                      fontSize: 16,
                      color: isOpen ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                Positioned(
                  left: 150,
                  bottom: 100,
                  child: GestureDetector(
                    onTap: toggleWallet,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      width: 100,
                      height: 20,
                      //color: Colors.transparent,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isOpen ? Icons.remove_red_eye : Icons.visibility_off,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            isOpen ? 'hide balance' : 'show balance',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
