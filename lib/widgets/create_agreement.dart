import 'package:flutter/material.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:fyp_project/sp/widgets/sp_appdrawer.dart';
import 'package:provider/provider.dart';

class CreateAgreement extends StatelessWidget {
  final String pdfText = """MEMBERSHIP RULES

1. Acceptance
WELCOME TO WeDo.

PLEASE READ THE FOLLOWING TERMS OF USE THOROUGHLY AND CAREFULLY. By using and / or browsing the Website, you agree that you have read, understood and agree to be bound by these Terms of Use.

If you do not agree with these Terms of Use, in while or in part, please discontinue using and / or browsing our Website immediately.

These Terms of Use shall be deemed to include our Privacy Policy and any Additional Policies. We may assign or change any part or parts of our rights under these Terms of Use without your consent or prior notification. The Terms of Use and Privacy Policy constitute a legally-binding agreement between us and you.


2. Your Submitted Content – Prohibitions, Representations and Warranties

You shall not upload, post, transmit, transfer, disseminate, distribute, or facilitate distribution of any content, including text, images, video, sound, data, information, or software, to any part of the Website including but not limited to (i) your profile; (ii) the posting of your Service; (iii) the posting of your desired Service; or (iv) the posting of any opinions or reviews in connection with the Website, the Service, the Service Professional, or the Service User (collectively referred to as "Submitted Content") that

i.   misrepresents the source of anything you post, including impersonation of another individual or entity of any false or inaccurate biographical information for any Service Professionals, provides or create links to external sites that violate this Terms of Use, is intended to harm or exploit any individual in any way or is designed to solicit, or collect personally identifiable information of any person without his or her express consent;

ii.   invades anyone's privacy by attempting to harvest, collect or otherwise utilize or publish any of their information without their knowledge and willing consent;

iii.   contains falsehoods or misrepresentations that could damage WeDo or any third party;


3. WeDo - Disclaimers and Right to Remove Submitted Content

i.  You are solely responsible for the photos, profiles and other content, including, without limitation, Submitted Content, that you publish or display on or through the Website, or transmit to other Website users. You understand and agree that WeDo may, in its sole discretion and without incurring any liability, review and delete or remove any Submitted Content that violates this Terms of Use or which might be offensive, illegal, or that might violate the rights, harm, or threaten the safety of Website users or others.


4. Fees and Taxes

i.   WeDo reserves the right ts sole discretion to charge fees to Service Users and / or Service Professionals for the WeDo Service and the use of the Application, including but not limited to fees for contacting Service Users, responding to requests from Service Users, or conducting transactions with Service Users through WeDo. WeDo reserves the right to charge fees for such facilities at its sole discretion and by using the Website, you agree to pay any such fees as WeDo may notify to you and prescribe from time to time.

ii.  SERVICE PROFESSIONALS ACKNOWLEDGE THAT THE TOTAL AMOUNT OF FEES PAID TO SERVICE PROFESSIONALS BY THE USERS INCLUDES THE SOFTWARE USAGE FEE, WHICH YOU ARE COLLECTING ON BEHALF OF WEDO. SUCH SOFTWARE USAGE FEE SHALL BE DETERMINED BY WEDO AT ITS DISCRETION, FROM TIME TO TIME.

iii. Users may choose to pay for the Services by cash and where available, by credit or debit card ("Card"), or bank transfer. In the event that the Users choose to pay for the Services by Card, all payments due to Service Professionals for the Services will be channeled to Service Professionals in the agreed quantum within 10 days from the date WeDo receives the payment.

iv.  WeDo retains the right to suspend the processing of any transaction where it reasonably believes that the transaction may be fraudulent, illegal or involves any criminal activity or where it reasonably believes the Users and Service Professionals to be in breach of the Terms and Conditions between the Service Professionals and Users and WeDo. In such an event, you shall not hold WeDo liable for any withholding of, delay in, suspension of or cancellation of, any payment to you.


5. Cancellation

i.  If the Customer cancel the task which the task is in progress, the WeDo party reserve the right to request the money from the customer.

ii. If the Customer does not satisfy the work done by the Service Provider, the Customer reserve the right to report to the Customer Service of WeDo to make report.

iii. WeDo will keep the money for 10 days. If there is no report from customer, the customer will not have the right to make any report about the related task.
""";

  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return SafeArea(
        child: new Scaffold(
            appBar: new AppBar(
              title: const Text('Terms And Condition'),
              // actions: [
              //   new FlatButton(
              //       onPressed: () {
              //         Navigator
              //             .of(context)
              //             .pop('User Agreed');
              //       },
              //       child: new Text('AGREE',
              //           style: Theme
              //               .of(context)
              //               .textTheme
              //               .subhead
              //               .copyWith(color: Colors.white)
              //               )),
              // ],
              
            ),
           drawer: authNotifier.userList[0].accounttype!='Customer'? SpAppDrawer():null,
            
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(pdfText),
              ),
            )));
  }
}
