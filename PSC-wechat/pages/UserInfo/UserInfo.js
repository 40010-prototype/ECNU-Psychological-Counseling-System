Page({
  data: {
    userInfo: {
      avatar: '',
      name: '',
      phone: '',
      email: ''
    }
  },

  onLoad: function() {
    this.fetchUserInfo();
  },

  onShow: function() {
    // 每次页面显示时重新获取用户信息
    this.fetchUserInfo();
  },

  // 获取用户信息
  fetchUserInfo: function() {
    // 从本地存储获取用户信息
    const userInfo = wx.getStorageSync('userInfo');
    if (userInfo) {
      this.setData({
        userInfo: userInfo
      });
    }
  },

  // 处理修改信息按钮点击
  handleEdit: function() {
    wx.navigateTo({
      url: '/pages/AddUserInfo/AddUserInfo'
    });
  }
}); 