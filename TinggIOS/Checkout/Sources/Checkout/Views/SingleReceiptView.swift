//
//  SingleReceiptView.swift
//  
//
//  Created by Abdulrasaq on 28/02/2023.
//
import CoreUI
import SwiftUI
import Theme
import Core
public struct SingleReceiptView: View {
    @Environment(\.dismiss) var dismiss
    private static let rightTitle = "Right title"
    @State var data = [
        DetailsVStackRightVStackLeftData(),
        DetailsVStackRightVStackLeftData()
    ]
    private var paymentStatusAdvice: String {
        switch color {
        case .green:
            return "Thank you!"
        case .red:
            return "Charge request failed"
        default:
            return "Processing payment"
        }
    }
    private var moreInfoOnPaymentStatus : String {
        switch color {
        case .green:
           return "Your payment was successful"
        case .red:
            return "It seems we are unable to process payment"
        default:
            return "Hold tight as we process your payment"
        }
    }
    var color: Color = .red
    private var smileyName = "face.smiling.fill"
    private var serviceName: String = "Service name"
    private var accountNumber = "Account number"
    private var model: TransactionItemModel = .sample
    private let imageSize = CGFloat(100)
    private let borderSize = CGFloat(108)
    public init(color: Color = .red,  model: TransactionItemModel = .sample) {
        self.color = color
        self.model = model
    }
    public var body: some View {
        VStack {
            HStack {
                Image(systemName: "xmark")
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
                Image(systemName: "square.and.arrow.up")
            }
            .padding()
            .foregroundColor(.white)

            ZStack {
                VStack {
                    VStack {
                        dividerDesign()
                        ForEach(data) { datum in
                            DetailsVStackRightVStackLeftView(data: datum)
                              
                        } .padding(10)
                        serviceInfoSection()
                        HStack {
                            Text("POWERED BY")
                                .font(.caption)
                                .bold()
                                .textCase(.uppercase)
                            PrimaryTheme.getImage(image: .tinggByCellulant)
                                .resizable()
                                .frame(width: 90, height: 40)
                                
                        }.padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                    )
                    .padding(10)
                    HorizontalLine()
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .frame(height: 1)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                    Text("Contact Support")
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                }
                header()
            }
        }
        .onAppear {
            let dateTitle = "Date"
            let date = model.date.formatted(with: "dd/MM/yyyy")
            let timeTitle = "Time"
            let time = model.date.formatted(with: "HH:mm")
            let paidToTitle = "Paid to"
            let smartCardTitle = model.service.referenceLabel 
            let amountTitle = "Amount"
            let transactionIDTitle = "Transaction ID"
            let detail1 = DetailsVStackRightVStackLeftData(
                titleRight: timeTitle,
                valueRight: time,
                titleLeft: dateTitle,
                valueLeft: date
            )
            let detail2 = DetailsVStackRightVStackLeftData(
                titleRight: smartCardTitle,
                valueRight: model.accountNumber,
                titleLeft: paidToTitle,
                valueLeft: model.service.serviceName
            )
            let detail3 = DetailsVStackRightVStackLeftData(
                titleRight: transactionIDTitle,
                valueRight: model.id,
                titleLeft: amountTitle,
                valueLeft: "\(model.currency)\(model.amount)"
            )
            
            data = [
                detail1, detail2, detail3
            ]
        }
        .background(color)
        
    }
    @ViewBuilder
    fileprivate func viewsForGreen() -> some View {
        Image(systemName: "face.smiling.fill")
            .foregroundColor(color)
            .font(.system(size: imageSize))
            .background(
                Circle()
                    .fill(.white)
                    .frame(width: borderSize, height: borderSize)
            )
    }
    @ViewBuilder
    fileprivate func viewsForRed() -> some View {
        PrimaryTheme.getImage(image: .sadFace)
            .resizable()
            .frame(width: imageSize, height: imageSize)
            .background(
                Circle()
                    .fill(.white)
                    .frame(width: borderSize, height: borderSize)
            )
    }
    @ViewBuilder
    fileprivate func defaultView() -> some View {
        Image(systemName: "timer.circle.fill")
            .foregroundColor(color)
            .font(.system(size: imageSize))
            .background(
                Circle()
                    .fill(.white)
                    .frame(width: borderSize, height: borderSize)
            )
    }
    
    fileprivate func header() -> some View {
        
        return VStack {
            switch color {
            case .green :
                viewsForGreen()
                
            case .red :
                viewsForRed()
                
            default:
                defaultView()
            }
            
            Text(paymentStatusAdvice)
                .bold()
                .foregroundColor(color)
            Text(moreInfoOnPaymentStatus)
                .font(.caption)
                .foregroundColor(color)
        }.alignmentGuide(VerticalAlignment.center) { d in
            d[.bottom] + 220
        }
        .padding( 10)
    }
    fileprivate func dividerDesign() -> some View {
        return HStack {
            Rectangle()
                .cornerRadius(20, corners: [.topRight, .bottomRight])
                .frame(width: 40, height: 25)
            Spacer()
            HorizontalLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(height: 1)
            Rectangle()
                .cornerRadius(20, corners: [.topLeft, .bottomLeft])

                .frame(width: 40, height: 25)
        }
        .padding(.top, 120)
        .foregroundColor(color)
    }
    
    fileprivate func serviceInfoSection() -> some View {
        return HStack {

            IconImageCardView(imageUrl: model.imageurl, x: 0, y: 0, shadowRadius: 0)

                .scaleEffect(0.7)
            VStack(alignment: .leading) {
                Text(model.payer.clientName)
                Text(model.accountNumber)
            }
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 2)
                .foregroundColor(.gray.opacity(0.5))
        )
        .padding(10)
    }

    @MainActor fileprivate func render(view: some View) -> URL {
        // 1: Render Hello World with some modifiers
        let renderer = ImageRenderer(content:
            view
        )

        // 2: Save it to our documents directory
        let url = URL.documentsDirectory.appending(path: "output.pdf")

        // 3: Start the rendering process
        renderer.render { size, context in
            // 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            // 5: Create the CGContext for our PDF pages
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }

            // 6: Start a new PDF page
            pdf.beginPDFPage(nil)

            // 7: Render the SwiftUI view data onto the page
            context(pdf)

            // 8: End the page and close the file
            pdf.endPDFPage()
            pdf.closePDF()
        }

        return url
    }
}

struct DetailsVStackRightVStackLeftView: View {
    var data: DetailsVStackRightVStackLeftData = .init()
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(data.titleLeft)
                    .font(.caption)
                Text(data.valueLeft)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(data.titleRight)
                    .font(.caption)
                Text(data.valueRight)
            }
        }.font(.subheadline)
        .bold()
    }
}

struct DetailsVStackRightVStackLeftData: Identifiable {
    var id = UUID().description
    var titleRight: String = "Right title"
    var valueRight: String = "Right value"
    var titleLeft: String = "Left title"
    var valueLeft: String = "Left value"
}

struct SingleReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        SingleReceiptView()
    }
}

struct HorizontalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
