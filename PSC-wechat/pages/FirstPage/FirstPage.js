const app = getApp()
Page({
    data: {
      // 自定义图片和文字
      bannerImage: '', 
      welcomeText: '欢迎来到心理咨询系统',
      descriptionText: '我们为您提供专业的心理咨询服务',
      isLoading: false,
      isAgreed: false,
      isLogin: true, // 控制登录/注册表单切换
      email: '',
      password: '',
      confirmPassword: '',
      baseUrl: app.globalData.BaseUrl, // 后端API基础地址
    },
  
    onLoad() {
      // 检查是否已经登录
      this.checkLoginStatus();
    },
  
    // 检查登录状态
    checkLoginStatus() {
      const token = wx.getStorageSync('token');
      if (token) {
        // 如果已经登录，直接跳转到主页
        wx.reLaunch({
          url: '/pages/MainPage/MainPage'
        });
      }
    },
  
    // 切换登录/注册表单
    switchToLogin() {
      this.setData({
        isLogin: true,
        email: '',
        password: '',
        confirmPassword: ''
      });
    },
  
    switchToRegister() {
      this.setData({
        isLogin: false,
        email: '',
        password: '',
        confirmPassword: ''
      });
    },
  
    // 处理输入
    handleEmailInput(e) {
      this.setData({
        email: e.detail.value
      });
    },
  
    handlePasswordInput(e) {
      this.setData({
        password: e.detail.value
      });
    },
  
    handleConfirmPasswordInput(e) {
      this.setData({
        confirmPassword: e.detail.value
      });
    },
  
    // 处理用户协议勾选
    handleAgreementChange(e) {
      this.setData({
        isAgreed: e.detail.value.length > 0
      });
    },
  
    // 显示用户协议
    showUserAgreement() {
      wx.showModal({
        title: '用户协议',
        content: '欢迎使用心理咨询小程序。本协议是您与心理咨询小程序之间就心理咨询服务等相关事宜所订立的契约。',
        showCancel: false
      });
    },
  
    // 显示隐私政策
    showPrivacyPolicy() {
      wx.showModal({
        title: '隐私政策',
        content: '我们非常重视您的隐私保护。本隐私政策将帮助您了解我们如何收集、使用和保护您的个人信息。',
        showCancel: false
      });
    },
  
    // 表单验证
    validateForm() {
      const { email, password, confirmPassword, isLogin, isAgreed } = this.data;
  
      if (!email || !password || (!isLogin && !confirmPassword)) {
        wx.showToast({
          title: '请填写完整信息',
          icon: 'none'
        });
        return false;
      }
  
      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        wx.showToast({
          title: '请输入有效的邮箱地址',
          icon: 'none'
        });
        return false;
      }
  
      if (!isLogin && password !== confirmPassword) {
        wx.showToast({
          title: '两次输入的密码不一致',
          icon: 'none'
        });
        return false;
      }
  
      if (!isAgreed) {
        wx.showToast({
          title: '请先同意用户协议和隐私政策',
          icon: 'none'
        });
        return false;
      }
  
      return true;
    },
  
    // 处理登录
    handleLogin() {
      if (this.data.isLoading) return;
      if (!this.validateForm()) return;
      
      this.setData({ isLoading: true });
  
      // 调用登录接口
      wx.request({
        url: `${this.data.baseUrl}/login`,
        method: 'POST',
        data: {
          email: this.data.email,
          password: this.data.password
        },
        success: (res) => {
          if (res.data.code === 1) {
            // 登录成功，保存用户信息和token
            const userInfo = {
              email: this.data.email,
              loginTime: new Date().getTime()
            };
            wx.setStorageSync('userInfo1', userInfo);
            wx.setStorageSync('token', res.data.data.token);
            
            // 检查是否需要完善信息
            if (res.data.needCompleteInfo) {
              wx.navigateTo({
                url: '/pages/AddUserInfo/AddUserInfo'
              });
            } else {
              wx.reLaunch({
                url: '/pages/MainPage/MainPage'
              });
            }
          } else {
            wx.showToast({
              title: res.data.message || '登录失败',
              icon: 'none'
            });
          }
        },
        fail: (err) => {
          console.error('登录请求失败：', err);
          wx.showToast({
            title: '登录失败，请重试',
            icon: 'none'
          });
        },
        complete: () => {
          this.setData({ isLoading: false });
        }
      });
    },
  
    // 处理注册
    handleRegister() {
      if (this.data.isLoading) return;
      if (!this.validateForm()) return;
  
      this.setData({ isLoading: true });
  
      // 调用注册接口
      wx.request({
        url: `${this.data.baseUrl}/register`,
        method: 'POST',
        data: {
          email: this.data.email,
          password: this.data.password
        },
        success: (res) => {
          if (res.data.code === 1) {
            wx.showToast({
              title: '注册成功',
              icon: 'success',
              duration: 2000,
              success: () => {
                // 注册成功后自动切换到登录页
                setTimeout(() => {
                  this.switchToLogin();
                }, 2000);
              }
            });
          } else {
            wx.showToast({
              title: res.data.message || '注册失败',
              icon: 'none'
            });
          }
        },
        fail: (err) => {
          console.error('注册请求失败：', err);
          wx.showToast({
            title: '注册失败，请重试',
            icon: 'none'
          });
        },
        complete: () => {
          this.setData({ isLoading: false });
        }
      });
    },
    
    showError(msg) {
      wx.showToast({
        title: msg,
        icon: 'none',
        duration: 2000
      });
    }
  });