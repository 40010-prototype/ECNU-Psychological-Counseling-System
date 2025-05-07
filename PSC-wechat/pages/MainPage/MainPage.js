// pages/MainPage/MainPage.js
const app = getApp();
Page({

    /**
     * 页面的初始数据
     */
    data: {
      // 访客信息
      visitorInfo: {
        name: "",
        phone: "",
        avatarUrl: "/images/default-avatar.png"
      },
      // 咨询记录数据
      scrollItems: [],
      // 页面高度
      pageHeight: 0,
      hasActiveSession: false,
      userInfo: null,
      baseUrl: 'http://localhost:3000',
      currentTab: 'chat',
      isConsulting: false,
      currentConsultant: null,
      consultantList: [],
      consultationHistory: [],
      userId: ''
    },

    /**
     * 生命周期函数--监听页面加载
     */
    onLoad(options) {
      // 获取系统信息设置页面高度
      const systemInfo = wx.getSystemInfoSync();
      this.setData({
        pageHeight: systemInfo.windowHeight
      });
      
      // 获取访客信息和咨询记录
      this.loadUserInfo();
      this.loadConsultationHistory();
      this.checkActiveSession();
    },

    /**
     * 生命周期函数--监听页面初次渲染完成
     */
    onReady() {

    },

    /**
     * 生命周期函数--监听页面显示
     */
    onShow() {
      this.loadUserInfo();
      this.loadConsultationHistory();
      this.checkActiveSession();
    },

    /**
     * 生命周期函数--监听页面隐藏
     */
    onHide() {

    },

    /**
     * 生命周期函数--监听页面卸载
     */
    onUnload() {
    },

    /**
     * 页面相关事件处理函数--监听用户下拉动作
     */
    onPullDownRefresh() {
      // 下拉刷新
      this.loadUserInfo();
      this.loadConsultationHistory();
      wx.stopPullDownRefresh();
    },

    /**
     * 页面上拉触底事件的处理函数
     */
    onReachBottom() {

    },

    /**
     * 用户点击右上角分享
     */
    onShareAppMessage() {

    },

    // 获取访客信息
    loadUserInfo() {
      const userInfo = wx.getStorageSync('userInfo') || {};
      this.setData({
        userInfo: userInfo,
        userId: userInfo.id || ''
      });
    },

    // 获取咨询记录
    loadConsultationHistory() {
        const counselor = wx.getStorageSync('selectedCounselor');
      const token = wx.getStorageSync('token');
      if (!token) return;

      wx.request({
        url: `${app.globalData.BaseUrl}`+'/sessions/messages?counselorId='+`${counselor.id}`,
        method: 'GET',
        header: {
          'token': token
        },
        success: (res) => {
          if (res.data.code === 1) {
            this.setData({
              scrollItems: res.data.data || []
            });
          }
        },
        fail: (err) => {
          console.error('获取咨询历史失败：', err);
        }
      });
    },

    // 格式化时间戳
    formatTimestamp(timestamp) {
      if (!timestamp) return '';
      
      const date = new Date(timestamp);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      const hours = String(date.getHours()).padStart(2, '0');
      const minutes = String(date.getMinutes()).padStart(2, '0');
      
      return `${year}-${month}-${day} ${hours}:${minutes}`;
    },

    // 处理在线咨询
    handleConsult() {
      if (this.data.hasActiveSession) {
        wx.switchTab({
          url: '/pages/Chatpage/Chatpage'
        });
      } else {
        wx.navigateTo({
          url: '/pages/Chat/Chat1'
        });
      }
    },

    // 导航到聊天页面
    navigateToChat(e) {
      const id = e.currentTarget.dataset.id;
      wx.navigateTo({
        url: `/pages/Chatpage/Chatpage?id=${id}`
      });
    },

    // 处理退出登录
    handleLogout() {
      wx.showModal({
        title: '确认退出',
        content: '确定要退出登录吗？',
        success: (res) => {
          if (res.confirm) {
            // 清除本地存储的用户信息
            wx.removeStorageSync('userInfo');
            wx.removeStorageSync('visitorInfo');
            
            // 跳转到登录页面
            wx.reLaunch({
              url: '/pages/FirstPage/FirstPage'
            });
          }
        }
      });
    },

    checkActiveSession() {
      const counselor = wx.getStorageSync('selectedCounselor');
      const hasActiveSession = counselor && counselor.id;
      
      if (hasActiveSession !== this.data.hasActiveSession) {
        this.setData({ hasActiveSession });
        
        // 更新tabBar
        wx.setTabBarItem({
          index: 1,
          text:  '咨询会话',
          pagePath: hasActiveSession ? 'pages/Chatpage/Chatpage' : 'pages/Chat/Chat1'
        });
      }
    }
})