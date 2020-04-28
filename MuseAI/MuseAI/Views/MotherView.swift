//
//  MotherView.swift
//  MuseAI
//
//  Created by Garrett Wayne on 4/27/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import SwiftUI

struct MotherView : View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            if viewRouter.currentPage == ViewState.START {
                StartPageView()
            }
            else if viewRouter.currentPage == ViewState.CREATE_ACCOUNT {
                CreateAccountView()
                    .transition(.scale)
            }
            else if viewRouter.currentPage == ViewState.LOGIN {
                LoginView()
                    .transition(.scale)
            }
            else if viewRouter.currentPage == ViewState.HOME {
                HomeView()
                    .transition(.scale)
            }
            else if viewRouter.currentPage == ViewState.KEYBOARD {
                KeyboardView()
                    .transition(.slide)
            }
        }
    }
}

#if DEBUG
struct MotherView_Previews : PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
#endif
