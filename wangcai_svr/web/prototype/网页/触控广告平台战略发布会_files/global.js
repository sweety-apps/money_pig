	/**
	* mini lib by brucewan
	*/
	(function(m){
		if(m) {
			return;
		}
		var vendors = [ "webkit", "moz", "o" ];
		var m = {
			extend: function (destination, source, override, replacer) {
				if (override === undefined) override = true;
				for (var property in source) {
					if (override || !(property in destination)) {
						if(replacer) replacer(property);
						else destination[property] = source[property];
					}
				}
				return destination;
			},
			support: {
				translate3d:  (function() {var sTranslate3D = "translate3d(0px, 0px, 0px)"; var eTemp = document.createElement("div"); eTemp.style.cssText = " -moz-transform:" + sTranslate3D + "; -ms-transform:" + sTranslate3D + "; -o-transform:" + sTranslate3D + "; -webkit-transform:" + sTranslate3D + "; transform:" + sTranslate3D; var rxTranslate = /translate3d\(0px, 0px, 0px\)/g; var asSupport = eTemp.style.cssText.match(rxTranslate); var bHasSupport = (asSupport !== null && asSupport.length == 1); return bHasSupport; })()
			},
			css: function(obj, prop, value){
				var needVendor = /transform/i;
				if(needVendor.test(prop)) {
					for(var i = 0; i < vendors.length; i++) {
						obj.style[vendors[i]+ prop.substr(0, 1).toUpperCase()+prop.substr(1)] = value;
					}
				}
				obj.style[prop] = value;
			}
		};
		window.m = m;
	})(window.m);


	m.Tab = function(config){
		this.config = m.extend(m.extend({}, m.Tab.config), config, true);
		this.init();
	};
	m.Tab.config = {
		touchMove: false,
		animTime: 500,
		touchDis: 40,
		currentClass: 'current'
	};
	m.Tab.prototype = {
		init: function(){
			var self = this;
			var c = self.config;

			self._data = {};

			self.target = c.target;
			self.trigger = c.trigger;
			self.num = self.target.length;
			self.wrap = self.target[0].parentNode;
			// self.wrap.cssText += ';-webkit-transition: all .5s linear;'
			if(m.support.translate3d) {
				self.wrap.style.webkitTransition = '-webkit-transform '+ c.animTime +'ms ease-out';
			}
			m.css(self.wrap, 'transform', 'translate(0,100px)');
			// self.width = self.wrap.parentNode.clientWidth;
			self.height = self.wrap.parentNode.clientHeight;
			self._attach();

			self.playTo(0);
		},

		_attach: function(){
			var self = this;
			var c = self.config;

			// 横竖屏切换时
			window.addEventListener('resize', self.update.bind(self));

			// 点击图标触发
//			if(self.trigger) {
//				var len = self.trigger.length;
//				for(var i = 0; i < len; i++) {
//					(function(i){
//						self.trigger[i].addEventListener('touchend', function(e){
//							self.playTo(i);
//						});
//					})(i);
//				}
//			}

			// 滑动屏幕触发
			var d = self._data;
//			var locked = false;
			var touchMove, touchEnd;
			if(c.touchMove) {
				self.wrap.addEventListener('touchstart', function(e){
					d.pageX = e.touches[0].pageX;
					d.pageY = e.touches[0].pageY;
					self.wrap.style.webkitTransitionDuration = '0ms';
					self.wrap.addEventListener('touchmove', touchMove);
					self.wrap.addEventListener('touchend', touchEnd);
					// self.wrap.addEventListener('touchcancel', touchEnd);
				});
			}
			touchMove = function(e){
				d.dis = e.touches[0].pageX - d.pageX;
				d.disY = e.touches[0].pageY - d.pageY;

				if(Math.abs(d.disY / d.dis) > 0.8) {
					e.stopPropagation();
					e.preventDefault();
				}

				// self.wrap.style.webkitTransform = 'translate3d(' + (d.dis - self.current * self.width) + 'px,0,0)';
				// m.css(self.wrap, 'transform', 'translate3d(' + (d.dis - self.current * self.width) + 'px,0,0)');//x轴移动
				m.css(self.wrap, 'transform', 'translate3d(0,' + (d.disY - self.current * self.height) + ',0)');
			}
			touchEnd = function() {
				var movetype = 'disY';
				if(d[movetype] === undefined || isNaN(d[movetype])) {
					d[movetype] = 0;
				}

				self.wrap.style.webkitTransitionDuration = c.animTime + 'ms';
				self.wrap.removeEventListener('touchmove', touchMove);
				self.wrap.removeEventListener('touchend', touchEnd);

				if(!d[movetype] || (Math.abs(d[movetype]) < c.touchDis)) {
					self.playTo(self.current);
					return;
				}
				if(d[movetype] > 0) {
					self.prev();
				} else {
					self.next();
				}

				d[movetype] = 0;

			};

//			// 用户点击时
//			self.wrap.addEventListener('click', function(e){
//				c.onclick && c.onclick.call(self, e);
//			});


		},

		playTo: function(i){
			var self = this;
			var c = self.config;

			if(i >= self.num -1) {
				i = self.num - 1;
			}
			if(i < 0) {
				i = 0;
			}
			/*if(m.support.translate3d) {
				m.css(self.wrap, 'transform', 'translate3d('+ (-this.width * i) +'px,0,0)');
			} else {
				m.css(self.wrap, 'transform', 'translate('+ (-this.width * i) +'px,0)');
			}*/
			if(m.support.translate3d) {
				m.css(self.wrap, 'transform', 'translate3d(0,'+ (-this.height * i) +'px,0)');
			} else {
				m.css(self.wrap, 'transform', 'translate(0,'+ (-this.height * i) +'px)');
			}
			// 如果还是当前页
			if(i === self.current) return;

			if(self.trigger && self.trigger[self.current]) {
				self.trigger[self.current].classList.remove(c.currentClass);
			}
			self.prevPage = self.current;
			self.current = i;
			if(self.trigger && self.trigger[self.current]) {
				self.trigger[self.current].classList.add(c.currentClass);
			}

			
			window.setTimeout(function(){
				c.onchange && c.onchange.apply(self, [i]);
			}, c.animTime);
		},
		prev: function(){
			this.playTo(this.current - 1);
		},
		next: function(){
			this.playTo(this.current + 1);
		},
		update: function(e){
			var self = this;
			// self.width = self.wrap.parentNode.clientWidth;
			self.height = self.wrap.parentNode.clientHeight;
		}
	}/*  |xGv00|deb5a35dcca125a4a8e71d0a43bb6ba6 */