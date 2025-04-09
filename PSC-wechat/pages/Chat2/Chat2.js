Page({
    data: {
      // 联系人列表
      contactList: [],
      loading: true,
      error: null
    },
  
    onLoad: function() {
      this.fetchContactList();
    },
  
    // 从后端获取联系人列表
    fetchContactList: function() {
      this.setData({ loading: true });
      const token = wx.getStorageSync('token');
      // 调用后端API获取联系人列表
      wx.request({
        url: 'YOUR_API_ENDPOINT/contacts', // 替换为您的实际API端点
        method: 'GET',
        data:{
            token : token
        },
        success: (res) => {
          if (res.statusCode === 1) {
            this.setData({
              contactList: res.data.contacts,
              loading: false
            });
          } else {
            this.setData({
              error: '获取联系人列表失败',
              loading: false
            });
            wx.showToast({
              title: '获取数据失败',
              icon: 'none'
            });
          }
        },
        fail: (err) => {
          this.setData({
            error: '网络请求失败',
            loading: false
          });
          wx.showToast({
            title: '网络错误',
            icon: 'none'
          });
        }
      });
    },
  
    // 处理联系人点击事件
    handleContactTap(e) {
      const { id } = e.currentTarget.dataset;
      const contact = this.data.contactList.find((item) => item.id === id);
      if (contact) {
        wx.navigateTo({
          url: `${contact.url}?id=${contact.id}&name=${contact.name}`,
        });
      }
    },
  
    // 下拉刷新
    onPullDownRefresh: function() {
      this.fetchContactList();
      wx.stopPullDownRefresh();
    }
  });