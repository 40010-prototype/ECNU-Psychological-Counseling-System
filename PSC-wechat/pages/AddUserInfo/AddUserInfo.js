Page({
  data: {
    avatarUrl: '',
    role: 'visitor', // 默认为访客
    name: '',
    phone: '',
    gender: 'male',
    age: '',
    emergencyContact: '',
    emergencyPhone: '',
    isSubmitting: false,
    isFormValid: false
  },

  onLoad: function() {
    // 获取本地存储的用户信息
    const userInfo = wx.getStorageSync('userInfo');
    if (userInfo) {
      this.setData({
        avatarUrl: userInfo.avatar || '',
        role: userInfo.role || 'visitor',
        name: userInfo.name || '',
        phone: userInfo.phone || '',
        gender: userInfo.gender || 'male',
        age: userInfo.age || '',
        emergencyContact: userInfo.emergencyContact || '',
        emergencyPhone: userInfo.emergencyPhone || ''
      });
      this.validateForm();
    }
  },

  // 处理头像选择
  handleChooseAvatar: function() {
    wx.chooseImage({
      count: 1,
      sizeType: ['compressed'],
      sourceType: ['album', 'camera'],
      success: (res) => {
        const tempFilePath = res.tempFilePaths[0];
        this.setData({
          avatarUrl: tempFilePath
        });
        this.validateForm();
      },
      fail: (error) => {
        console.error('选择图片失败:', error);
        wx.showToast({
          title: '选择图片失败',
          icon: 'none'
        });
      }
    });
  },

  // 处理身份选择
  handleRoleChange(e) {
    this.setData({ role: e.detail.value });
    this.validateForm();
  },

  // 处理姓名输入
  handleNameInput(e) {
    this.setData({ name: e.detail.value });
    this.validateForm();
  },

  // 处理电话输入
  handlePhoneInput(e) {
    this.setData({ phone: e.detail.value });
    this.validateForm();
  },

  // 处理性别选择
  handleGenderChange(e) {
    this.setData({ gender: e.detail.value });
    this.validateForm();
  },

  // 处理年龄输入
  handleAgeInput(e) {
    this.setData({ age: e.detail.value });
    this.validateForm();
  },

  // 处理紧急联系人输入
  handleEmergencyContactInput(e) {
    this.setData({ emergencyContact: e.detail.value });
    this.validateForm();
  },

  // 处理紧急联系电话输入
  handleEmergencyPhoneInput(e) {
    this.setData({ emergencyPhone: e.detail.value });
    this.validateForm();
  },

  // 验证表单
  validateForm() {
    const { avatarUrl, role, name, phone, age, emergencyContact, emergencyPhone } = this.data;
    const isNameValid = name.length >= 2;
    const isPhoneValid = /^1[3-9]\d{9}$/.test(phone);
    const isAgeValid = age > 0 && age < 120;
    const isEmergencyContactValid = emergencyContact.length >= 2;
    const isEmergencyPhoneValid = /^1[3-9]\d{9}$/.test(emergencyPhone);

    this.setData({
      isFormValid: isNameValid && isPhoneValid && isAgeValid && 
                  isEmergencyContactValid && isEmergencyPhoneValid
    });
  },

  // 上传头像
  async uploadAvatar(tempFilePath) {
    try {
      const res = await new Promise((resolve, reject) => {
        wx.uploadFile({
          url: 'http://127.0.0.1:4523/m1/6011225-5700055-default/upload/avatar',
          filePath: tempFilePath,
          name: 'avatar',
          header: {
            'Authorization': `Bearer ${wx.getStorageSync('token')}`
          },
          success: resolve,
          fail: reject
        });
      });

      if (res.statusCode === 1) {
        const data = JSON.parse(res.data);
        return data.url;
      } else {
        throw new Error('上传头像失败');
      }
    } catch (error) {
      console.error('上传头像失败:', error);
      throw error;
    }
  },

  // 提交表单
  async handleSubmit() {
    if (!this.data.isFormValid || this.data.isSubmitting) return;
    
    const token = wx.getStorageSync('token');
    this.setData({ isSubmitting: true });

    try {
      let avatarUrl = this.data.avatarUrl;
      
      // 如果是本地临时文件，需要先上传
      if (avatarUrl.startsWith('wxfile://')) {
        avatarUrl = await this.uploadAvatar(avatarUrl);
      }

      const res = await new Promise((resolve, reject) => {
        wx.request({
          url: 'http://127.0.0.1:4523/m1/6011225-5700055-default',
          method: 'POST',
          data: {
            avatarUrl,
            token: token,
            role: this.data.role,
            name: this.data.name,
            phone: this.data.phone,
            gender: this.data.gender,
            age: parseInt(this.data.age),
            emergencyContact: this.data.emergencyContact,
            emergencyPhone: this.data.emergencyPhone
          },
          success: resolve,
          fail: reject
        });
      });

      if (res.data.code === 1) {
        // 保存用户信息到本地存储
        const userInfo = {
          avatarUrl,
          role: this.data.role,
          name: this.data.name,
          phone: this.data.phone,
          gender: this.data.gender,
          age: this.data.age,
          emergencyContact: this.data.emergencyContact,
          emergencyPhone: this.data.emergencyPhone
        };
        wx.setStorageSync('userInfo', userInfo);

        wx.showToast({
          title: '提交成功',
          icon: 'success'
        });
        
        // 延迟跳转到主页
        setTimeout(() => {
          wx.reLaunch({
            url: '/pages/MainPage/MainPage'
          });
        }, 1500);
      } else {
        throw new Error(res.data.message || '提交失败');
      }
    } catch (error) {
      console.error('提交失败:', error);
      wx.showToast({
        title: error.message || '提交失败',
        icon: 'none'
      });
    } finally {
      this.setData({ isSubmitting: false });
    }
  }
}); 