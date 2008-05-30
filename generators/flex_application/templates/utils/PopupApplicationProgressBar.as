

package com.<%= file_name %>.util {
	
	import mx.controls.Alert;
	import mx.containers.TitleWindow;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	import mx.controls.ProgressBar;
	import mx.rpc.IResponder;
	
	import com.<%= file_name %>.components.ProgressPopup;
	
	public class PopupApplicationProgressBar implements IResponder {
		
		public var totalProgressSteps:int = 0;
		public var currentProgress:int = 0;
		
		private var popup:ProgressPopup = null;
		
		public function incrementTotalProgressSteps():void {
			totalProgressSteps += 1;
			if(popup == null) { popup = new PopupProgress(); }
			if(totalProgressSteps == 1) {
				PopUpManager.addPopUp(popup, Application(Application.application), true);
				PopUpManager.centerPopUp(popup);
			}
			popup.progressBar.setProgress(0, totalProgressSteps);
		}

		public function incrementCurrentProgress():void {
			currentProgress +=1;
			popup.progressBar.setProgress(currentProgress, totalProgressSteps);
			if(currentProgress == totalProgressSteps) {
				currentProgress = totalProgressSteps = 0;
				PopUpManager.removePopUp(popup);
			} else {
			}
		}
		
		public function fault(obj:Object):void {
			incrementCurrentProgress();
		}
		
		public function result(obj:Object):void {
			incrementCurrentProgress();
		}


		private static var progressBar:PopupApplicationProgressBar = null;

		public static function getInstance():PopupApplicationProgressBar{
		    if (progressBar == null) {
		        progressBar = new PopupApplicationProgressBar();
		    }
		    return progressBar;
		}

		//The constructor should be private, but this is not
		//possible in ActionScript 3.0. So, throwing an Error if
		//a second is created is the best we
		//can do to implement the Singleton pattern.
		public function PopupApplicationProgressBar() {
		    if (progressBar != null) {
		        throw new Error("Only one PopupApplicationProgressBar instance may be instantiated.");
		    }
		}
		
	}
}