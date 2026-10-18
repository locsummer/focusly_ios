import SwiftUI

public struct CircularProgressView: View {
    public let progress: Double
    public let lineWidth: CGFloat
    public let primaryColor: Color
    public let secondaryColor: Color
    
    public init(
        progress: Double,
        lineWidth: CGFloat = 16,
        primaryColor: Color = Color(red: 0.2, green: 0.78, blue: 0.35),
        secondaryColor: Color = Color.gray.opacity(0.2)
    ) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(secondaryColor, lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [primaryColor.opacity(0.8), primaryColor]),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeInOut(duration: 0.6), value: progress)
        }
    }
}
